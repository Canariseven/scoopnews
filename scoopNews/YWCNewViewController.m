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
@interface YWCNewViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate, NSURLSessionTaskDelegate,CLLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet UIProgressView *progress;
@property (nonatomic, strong) NSURLSessionUploadTask *uploadTask;
@property (nonatomic, strong) NSURLSession *mySession;
@property (nonatomic, strong) NSURLSession *session;
@property (nonatomic, strong) YWCNewsModel *model;
@property (nonatomic, strong) YWCLibraryNews *libraryNews;
@property (nonatomic, strong) YWCProfile *userProfile;
@property (nonatomic, strong) YWClocationModel *location;
@property (nonatomic, strong) NSString *sasURL;
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
    
}

-(void)sincronizeView{
    if (self.model == nil) {
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
        
        
    }else{
        self.publishButton.hidden = true;
        self.segmentValorator.hidden = false;
        self.dateNew.text = [NSString stringWithFormat:@"%@",[NSDate date]];
        self.titleNewTextField.text = self.model.titleNew;
        self.textNew.text = self.model.textNew;
        self.dateNew.text = self.model.creationDate;
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
    [self setupKVO];
    [self sincronizeView];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self tearDownKVO];
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
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    [self dismissViewControllerAnimated:YES completion:nil];
    [self obtenerImage:image];
    
}
-(void)obtenerImage:(UIImage *)image{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"dd_m_yyyy_HH_mm_ss"];
    NSString *dateSTR = [dateFormatter stringFromDate:[NSDate date]];
    
    NSString *nameResource = [NSString stringWithFormat:@"%@_%@.jpg",self.userProfile.idUser,dateSTR];
    NSDictionary *item = @{@"containerName":@"news",@"resourceName":nameResource};
    NSDictionary *params = @{@"blobName":nameResource,@"item":item,@"permissions":@"w"};
    
    [self.libraryNews.client invokeAPI:@"geturlblob"
                                  body:nil
                            HTTPMethod:@"get"
                            parameters:params
                               headers:nil
                            completion:^(id result, NSHTTPURLResponse *response, NSError *error) {
                                self.sasURL = nameResource;
                                NSURL *url = [NSURL URLWithString:[result valueForKey:@"sasUrl"]];
                                NSLog(@"%@",url);
                                [self uploadImage:image withSasURL:url];
                                self.image.image = image;
                            }];
}
// stop upload
- (IBAction)cancelUpload:(id)sender {
    if (_uploadTask.state == NSURLSessionTaskStateRunning) {
        [_uploadTask cancel];
    }
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
    });
    
    if (!error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"%@",task.response);
        });
    } else {
        //error
    }
}

-(void)finishUploadSincronizeViews{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    _progress.hidden = YES;
    _progress.progress = 0;
}


- (IBAction)publiButton:(id)sender {
    
    
}

- (IBAction)locationButton:(id)sender {
    
    YWCMapViewController *mapVC = [[YWCMapViewController alloc]initWithNewModelLocation:self.location];
    [self.navigationController pushViewController:mapVC animated:YES];
}
#pragma mark - Utils

-(void)saveMyNew:(id)sender{
    
    self.model = [[YWCNewsModel alloc]initWithTitleNew:self.titleNewTextField.text
                                               textNew:self.textNew.text
                                              stateNew:@"noPublic"
                                                rating:0
                                              imageURL:self.sasURL
                                                author:self.userProfile
                                              location:self.location
                                          creationDate:self.dateNew.text
                                                client:self.userProfile.client];
    MSTable *table = [[MSTable alloc]initWithName:@"news" client:self.libraryNews.client];
    NSDictionary *dict = [YWCNewsModel dictionaryWithModel:self.model];
    
    [table insert:dict completion:^(NSDictionary *item, NSError *error) {
        if (!error) {
            NSUInteger index = [self.libraryNews.myNews count];
            [self.libraryNews.myNews insertObject:self.model atIndex:index];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            NSLog(@"Error %@",error);
        }
        
    }];
}

- (IBAction)sendVote:(id)sender {
    NSNumber * puntos =[NSNumber numberWithInteger:self.segmentValorator.selectedSegmentIndex + 1];
    self.segmentValorator.hidden = YES;
    
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

-(void)setupKVO{
    NSArray *arr = [self.userProfile observableKeyNames];
    for (NSString *key in arr) {
        [self.userProfile addObserver:self
                           forKeyPath:key
                              options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                              context:NULL];
    }
    
    [self.model addObserver:self
                 forKeyPath:@"image"
                    options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                    context:NULL];
}
-(void)tearDownKVO{
    NSArray *arr = [self.userProfile observableKeyNames];
    for (NSString *key in arr) {
        [self.userProfile removeObserver:self
                              forKeyPath:key];
        
    }
    
    
    if (self.model.observationInfo != nil) {
        [self.model removeObserver:self
                        forKeyPath:@"image"];
    }
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
