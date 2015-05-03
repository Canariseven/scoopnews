//
//  YWCNewViewController.m
//  scoopNews
//
//  Created by Carmelo Ruymán Quintana Santana on 29/4/15.
//  Copyright (c) 2015 Carmelo Ruymán Quintana Santana. All rights reserved.
//
#import "UIImage+Resize.h"
#import "YWCNewViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "services.h"
#import "YWCLibraryNews.h"
#import "YWCProfile.h"
#import "YWCNewsModel.h"
#import "YWClocationModel.h"
#import "YWCMapViewController.h"
#import "settings.h"

#import "GAI.h"
#import "GAIDictionaryBuilder.h"
@interface YWCNewViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate, NSURLSessionTaskDelegate,CLLocationManagerDelegate>

@property (nonatomic, copy) NSString *statusPublic;
@property (weak, nonatomic) IBOutlet UIProgressView *progress;
@property (nonatomic, strong) NSURLSessionUploadTask *uploadTask;
@property (nonatomic, strong) NSURLSession *mySession;
@property (nonatomic, strong) NSURLSession *session;
@property (nonatomic, strong) YWCNewsModel *model;
@property (nonatomic, strong) YWCLibraryNews *libraryNews;
@property (nonatomic, strong) YWCProfile *userProfile;
@property (nonatomic, strong) YWClocationModel *location;
@property (nonatomic, copy) NSString *sasURL;
@end

@implementation YWCNewViewController
-(id)initWithlibrary:(YWCLibraryNews *)library{
    if (self = [super initWithNibName:nil bundle:nil]) {
        _userProfile = library.user;
        _libraryNews = library;
        
    }
    return self;
}
-(id)initWithNewsModel:(YWCNewsModel *)newsModel{
    if (self = [super initWithNibName:nil bundle:nil]) {
        _userProfile = newsModel.author;
        _model = newsModel;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];

    self.progress.hidden = YES;

    // Do any additional setup after loading the view.
    self.screenName = @"Detail Screen";
}

-(void)sincronizeView{
    if (self.model == nil) {
        _model = [[YWCNewsModel alloc]init];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(choosePhoto:)];
        [self.image addGestureRecognizer:tap];
        self.image.userInteractionEnabled = YES;
        UIBarButtonItem *save = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self
                                                                             action:@selector(saveMyNew:)];
        self.navigationItem.rightBarButtonItem = save;
        self.segmentValorator.hidden = true;
        self.publishButton.hidden = false;
        self.dateNew.text = [NSString stringWithFormat:@"%@",[NSDate date]];
        if ( self.location == nil){
            self.location = [[YWClocationModel alloc]init];
        }
        self.location.locationManager.delegate = self;
        self.voteButton.hidden = YES;
    }else{
        self.segmentValorator.hidden = false;
        self.dateNew.text = [NSString stringWithFormat:@"%@",[NSDate date]];
        self.titleNewTextField.text = self.model.titleNew;
        self.textNew.text = self.model.textNew;
        self.dateNew.text = self.model.creationDate;
    }
    if (self.model.author.idUser != self.userProfile.idUser) {
        self.publishButton.hidden = true;
    }
    if (self.userProfile.statusLogin == NO ) {
        self.publishButton.hidden = true;
    }
    if ([self.model.stateNew isEqualToString:@"public"] || [self.model.stateNew isEqualToString:@"toPublic"]) {
        self.publishButton.backgroundColor = [UIColor grayColor];
        [self.publishButton setTitle:@"Publicada" forState:UIControlStateDisabled];
        self.publishButton.enabled = NO;
    }
    
    [self.userProfile downloadImage];
    self.profilePhoto.image = self.userProfile.image;
    self.authorName.text = self.userProfile.nameUser;
    self.publishButton.layer.cornerRadius = self.publishButton.frame.size.height/2;
    self.locationButton.layer.cornerRadius = self.locationButton.frame.size.height/2;
    self.contentViewImageProfile.layer.cornerRadius = self.contentViewImageProfile.frame.size.height/2;
    self.image.image = self.model.image;
    self.profilePhoto.image = self.userProfile.image;
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.userProfile setupKVO:self];
    [self.model setupKVO:self];
    [self sincronizeView];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.model tearDownKVO:self];
    [self.userProfile tearDownKVO:self];
}

- (void)choosePhoto:(id)sender
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.allowsEditing = NO;
    picker.delegate = self;
    [self presentViewController:picker animated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate methods
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    __block UIImage *img = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    CGFloat screenScale = [[UIScreen mainScreen] scale];
    CGSize screenSize = CGSizeMake(screenBounds.size.width / screenScale, screenBounds.size.height / screenScale);
    
    
    // Hay que salir de aquí, androidero el último
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        img = [img resizedImage:screenSize interpolationQuality:kCGInterpolationMedium];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"dd_m_yyyy_HH_mm_ss"];
        NSString *dateSTR = [dateFormatter stringFromDate:[NSDate date]];
        NSString *nameResource = [NSString stringWithFormat:@"%@_%@.jpg",self.userProfile.idUser,dateSTR];
        self.sasURL = nameResource;
        dispatch_async(dispatch_get_main_queue(), ^{
            self.image.image = img;
            self.model.image = img;
        });
    });
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    
    
}
-(void)obtenerImage:(UIImage *)image{
    
    NSDictionary *item = @{@"containerName":@"news",@"resourceName":self.sasURL};
    NSDictionary *params = @{@"blobName":self.sasURL,@"item":item,@"permissions":@"w"};
    
    [self.libraryNews.client invokeAPI:@"geturlblob"
                                  body:nil
                            HTTPMethod:@"get"
                            parameters:params
                               headers:nil
                            completion:^(id result, NSHTTPURLResponse *response, NSError *error) {
                                NSURL *url = [NSURL URLWithString:[result valueForKey:@"sasUrl"]];
                                NSLog(@"%@",url);
                                [self uploadImage:image withSasURL:url];
                                self.image.image = image;
                            }];
}

- (void)uploadImage:(UIImage*)image withSasURL:(NSURL *)sasUrl{
    _progress.hidden = NO;
    _progress.progress = 0;
    NSData *imageData = UIImageJPEGRepresentation(image, 0.6);
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *upLoadSession = [NSURLSession sessionWithConfiguration:config
                                                                delegate:self
                                                           delegateQueue:nil];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:sasUrl
                                                                cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                            timeoutInterval:60.0];
    config.HTTPAdditionalHeaders = @{@"api-key" : AZURE_CONTENT_KEY};
    [request setHTTPBody:imageData];
    [request setHTTPMethod:@"PUT"];
    [request setValue:@"image/jpeg" forHTTPHeaderField:@"Content-Type"];
    self.uploadTask = [upLoadSession uploadTaskWithRequest:request fromData:imageData];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [_uploadTask resume];
}

#pragma mark - NSURLSessionTaskDelegate methods

- (void)URLSession:(NSURLSession *)session
              task:(NSURLSessionTask *)task
   didSendBodyData:(int64_t)bytesSent
    totalBytesSent:(int64_t)totalBytesSent
totalBytesExpectedToSend:(int64_t)totalBytesExpectedToSend{
    dispatch_async(dispatch_get_main_queue(), ^{
        [_progress setProgress:
         (double)totalBytesSent /
         (double)totalBytesExpectedToSend animated:YES];
    });
}

- (void)URLSession:(NSURLSession *)session
              task:(NSURLSessionTask *)task
didCompleteWithError:(NSError *)error{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self finishUploadSincronizeViews];
        self.title = @"Se ha subido la noticia correctamente";
    });
    
    if (!error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"%@",task.response);
            id<GAITracker> tracker = [GAI sharedInstance].defaultTracker;
            [tracker send:[GAIDictionaryBuilder createEventWithCategory:@"Nueva noticia Creada"
                                                                 action:@"Creación"
                                                                  label:self.userProfile.idUser
                                                                  value:nil].build];
            
            
            [self.navigationController popViewControllerAnimated:YES];
        });
    } else {
        self.title = @"Error al subir la noticia";
    }
}

-(void)finishUploadSincronizeViews{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    _progress.hidden = YES;
    _progress.progress = 0;
}


- (IBAction)publiButton:(id)sender {
    if ([self.model.stateNew isEqualToString:@"noPublic"]) {
        self.model.stateNew = @"toPublic";
        
        self.publishButton.backgroundColor = [UIColor greenColor];
        [self checkUploadStatusPublic];
    }
    
}

-(void)checkUploadStatusPublic{
    if (self.model.idNews.length >0) {
        // Actualizar
        MSTable *table = [[MSTable alloc]initWithName:@"news" client:self.model.client];
        NSDictionary *dict = [YWCNewsModel dictionaryWithModelToUpdate:self.model];
        
        [table update:dict completion:^(NSDictionary *item, NSError *error) {
            if (!error){
                NSLog(@"%@",item);
            }else{
                NSLog(@"%@",error);
            }
            
        }];
    }
}

- (IBAction)locationButton:(id)sender {
    
    YWCMapViewController *mapVC = [[YWCMapViewController alloc]initWithNewModelLocation:self.location];
    [self.navigationController pushViewController:mapVC animated:YES];
}
#pragma mark - Utils

-(void)saveMyNew:(id)sender{
    
    self.model = [[YWCNewsModel alloc]initWithTitleNew:self.titleNewTextField.text
                                               textNew:self.textNew.text
                                              stateNew:self.statusPublic
                                                rating:0
                                              imageURL:self.sasURL
                                                author:self.userProfile
                                              location:self.location
                                          creationDate:self.dateNew.text
                                                client:self.userProfile.client
                                                 image:self.image.image];
    
    MSTable *table = [[MSTable alloc]initWithName:@"news" client:self.libraryNews.client];
    NSDictionary *dict = [YWCNewsModel dictionaryWithModel:self.model];
    
    [table insert:dict completion:^(NSDictionary *item, NSError *error) {
        if (!error) {
            [self obtenerImage:self.image.image];
            
        }else{
            NSLog(@"Error %@",error);
        }
        
    }];
}

- (IBAction)sendVote:(id)sender {
    NSNumber * puntos =[NSNumber numberWithInteger:self.segmentValorator.selectedSegmentIndex + 1];
    self.voteButton.hidden = YES;
    self.segmentValorator.userInteractionEnabled = NO;
    NSDictionary *dict = @{@"rating":puntos,
                           @"idNews":self.model.idNews};
    
    [self.model.client invokeAPI:@"setrating"
                            body:nil
                      HTTPMethod:@"GET"
                      parameters:dict
                         headers:nil
                      completion:^(id result, NSHTTPURLResponse *response, NSError *error) {
                          NSLog(@"%@",response);
                      }];
}

#pragma mark - CLLocationManagerDelegate
-(void) locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations{
    
    // paramos el location manager, que consume mucha bateria
    [self zapLocationManager];
    if (self.location == nil) {
        CLLocation *loc = [locations lastObject];
        self.location = [YWClocationModel locationWith:loc];
    }else{
        NSLog(@"No deberíamos llegar aquí jamás");
    }
}

#pragma mark - Utils
-(void)zapLocationManager{
    [self.location.locationManager stopUpdatingLocation];
    self.location.locationManager.delegate = nil;
    self.location.locationManager = nil;
}


-(void)observeValueForKeyPath:(NSString *)keyPath
                     ofObject:(id)object
                       change:(NSDictionary *)change
                      context:(void *)context{
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([keyPath isEqualToString:@"nameUser"]) {
            
        }else if ([keyPath isEqualToString:@"image"] && [object isKindOfClass:[YWCProfile class]]){
            self.profilePhoto.image = self.userProfile.image;
        }else{
            self.image.image = self.model.image;
        }
    });
}



@end
