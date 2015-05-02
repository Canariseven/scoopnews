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
@end

@implementation YWCNewViewController
-(id)initWithUserProfile:(YWCProfile *)userProfile andLibrary:(YWCLibraryNews *)library{
    if (self = [super initWithNibName:nil bundle:nil]) {
        _userProfile = userProfile;
        _libraryNews = library;
    }
    return self;
}
-(id)initWithNewsModel:(YWCNewsModel *)newsModel{
    if (self = [super initWithNibName:nil bundle:nil]) {
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
                    self.voteButton.hidden = YES;
        self.publishButton.hidden = false;
        self.dateNew.text = [NSString stringWithFormat:@"%@",[NSDate date]];
        self.authorName.text = self.libraryNews.user.nameUser;
        if ( self.location == nil){
            self.location = [[YWClocationModel alloc]init];
        }
            self.location.locationManager.delegate = self;

    }else{
//        self.publishButton.hidden = true;
        self.segmentValorator.hidden = false;
        self.authorName.text = self.libraryNews.user.nameUser;
        self.dateNew.text = [NSString stringWithFormat:@"%@",[NSDate date]];
        self.titleNewTextField.text = self.model.titleNew;
        self.textNew.text = self.model.textNew;
        self.dateNew.text = self.model.creationDate;
        self.authorName.text = self.model.author.nameUser;
    }
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self sincronizeView];
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
    self.image.image = image;
    
    [self obtenerImage:image];
    
}
-(void)obtenerImage:(UIImage *)image{
    
    NSDictionary *item = @{@"containerName":@"news",@"resourceName":@"casa.jpg"};
    NSDictionary *params = @{@"blobName":@"casadddd.jpg",@"item":item};
    [self.libraryNews.client invokeAPI:@"geturlblob"
                            body:nil
                      HTTPMethod:@"get"
                      parameters:params
                         headers:nil
                      completion:^(id result, NSHTTPURLResponse *response, NSError *error) {
                          NSLog(@"%@",result);
//                          [self uploadImage:image withSasURL:[result valueForKey:@"sasUrl"] completionHandleSaS:^(id result, NSError *error) {
//                              
//                          }];
                          NSData *imageData = UIImageJPEGRepresentation(image, 0.6);

                          NSURL *url = [NSURL URLWithString:[result valueForKey:@"sasUrl"]];
                                                    NSLog(@"%@",url);
                          [self uploadPhotoToAzureStorageWithData:imageData toURL:url];
                          
                      }];
}
// stop upload
- (IBAction)cancelUpload:(id)sender {
    if (_uploadTask.state == NSURLSessionTaskStateRunning) {
        [_uploadTask cancel];
    }
}

//- (void)uploadImage:(UIImage*)image withSasURL:(NSString *)sasUrl completionHandleSaS:(void (^)(id result, NSError *error))completion{
//    NSData *imageData = UIImageJPEGRepresentation(image, 0.6);
//    
//    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
//    config.HTTPMaximumConnectionsPerHost = 1;
//    
//    NSURLSession *upLoadSession = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:nil];
//    NSURL *blobURL = [NSURL URLWithString:sasUrl];
//    
//    config.HTTPAdditionalHeaders = @{@"api-key" : AZURE_KEY};
//
//
//    
//    
//    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:blobURL];
//    [request setHTTPMethod:@"POST"];
//    [request setValue:@"image/jpeg" forHTTPHeaderField:@"Content-Type"];
//    
//    self.uploadTask = [upLoadSession uploadTaskWithRequest:request fromData:imageData];
//    
//    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
//    
//    [_uploadTask resume];
//}

-(void) uploadPhotoToAzureStorageWithData: (NSData *) imageData toURL: (NSURL *) sasURL{
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    config.HTTPAdditionalHeaders = @{@"api-key" : AZURE_CONTENT_KEY};
    
    NSURLSession *upLoadSession = [NSURLSession sessionWithConfiguration:config
                                                                delegate:nil
                                                           delegateQueue:nil];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:sasURL
                                                                cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                            timeoutInterval:60.0];
    
    [request setHTTPMethod:@"PUT"];
    [request addValue:@"image/jpeg" forHTTPHeaderField:@"Content-Type"];
    
    [request setHTTPBody:imageData];
    
    self.uploadTask = [upLoadSession uploadTaskWithRequest:request fromData:imageData completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (!error) {
            NSLog(@"%@",response);
        }else{
            NSLog(@"%@",error);
        }
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];

    }];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    [self.uploadTask resume];
}
#pragma mark - NSURLSessionTaskDelegate methods

- (void)URLSession:(NSURLSession *)session
              task:(NSURLSessionTask *)task
   didSendBodyData:(int64_t)bytesSent
    totalBytesSent:(int64_t)totalBytesSent
totalBytesExpectedToSend:(int64_t)totalBytesExpectedToSend
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [_progress setProgress:
         (double)totalBytesSent /
         (double)totalBytesExpectedToSend animated:YES];
    });
}

- (void)URLSession:(NSURLSession *)session
              task:(NSURLSessionTask *)task
didCompleteWithError:(NSError *)error
{
    // 1
    dispatch_async(dispatch_get_main_queue(), ^{
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        //        _uploadView.hidden = YES;
        [_progress setProgress:0.5];
    });
    
    if (!error) {
        // 2
        dispatch_async(dispatch_get_main_queue(), ^{
            //            [self refreshPhotos];
        });
    } else {
        // Alert for error
    }
}




//(ResponseType type, id response)

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
                                              imageURL:@""
                                                author:self.userProfile
                                              location:self.location
                                          creationDate:self.dateNew.text];
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
    self.voteButton.hidden = YES;
    NSDictionary *dict = @{@"rating":puntos, @"idNews":self.model.idNews};
    [self.model.client invokeAPI:@"setrating" body:nil HTTPMethod:@"GET" parameters:dict headers:nil completion:^(id result, NSHTTPURLResponse *response, NSError *error) {
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

@end
