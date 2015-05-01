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
@interface YWCNewViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate, NSURLSessionTaskDelegate>
@property (weak, nonatomic) IBOutlet UIProgressView *progress;
@property (nonatomic, strong) NSURLSessionUploadTask *uploadTask;
@property (nonatomic, strong) NSURLSession *mySession;
@property (nonatomic, strong) NSURLSession *session;
@property (nonatomic, strong) MSClient *client;
@property (nonatomic, strong) YWCNewsModel *model;
@property (nonatomic, strong) YWCLibraryNews *libraryNews;
@property (nonatomic, strong) YWCProfile *userProfile;
@end

@implementation YWCNewViewController
-(id)initWithClient:(MSClient *)client userProfile:(YWCProfile *)userProfile andLibrary:(YWCLibraryNews *)library{
    if (self = [super initWithNibName:nil bundle:nil]) {
        _client = client;
        _userProfile = userProfile;
        _libraryNews = library;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(choosePhoto:)];
    [self.image addGestureRecognizer:tap];
    self.image.userInteractionEnabled = YES;
    
    
    UIBarButtonItem *add = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self
                                                                        action:@selector(saveMyNew:)];
    self.navigationItem.rightBarButtonItem = add;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    
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
    
}
-(void)obtenerImage{
    
    NSDictionary *item = @{@"containerName":@"news",@"resourceName":@"casa.jpg"};
    NSDictionary *params = @{@"blobName":@"casa.jpg",@"item":item};
    [self.client invokeAPI:@"uploadblob"
                      body:nil
                HTTPMethod:@"PUT"
                parameters:params
                   headers:nil
                completion:^(id result, NSHTTPURLResponse *response, NSError *error) {
                    
                }];
}
// stop upload
- (IBAction)cancelUpload:(id)sender {
    if (_uploadTask.state == NSURLSessionTaskStateRunning) {
        [_uploadTask cancel];
    }
}

- (void)uploadImage:(UIImage*)image withSasURL:(NSString *)sasUrl{
    NSData *imageData = UIImageJPEGRepresentation(image, 0.6);
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    config.HTTPMaximumConnectionsPerHost = 1;
    
    NSURLSession *upLoadSession = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:nil];
    NSURL *blobURL = [NSURL URLWithString:sasUrl];
    
    //    config.HTTPAdditionalHeaders= @{@"ARRAffinity":@"7d51198690a579fd20a213541db9f01e2eb110d00725cc11a85f3f7a0f13f391",
    //                                     @"_gat":@"1",
    //                                     @"account":@"canarisevenblob",
    //                                     @"key":@"EdUlm1oXs5hd6GnQMdDz6TjfivZmuIqR6z1qXQJasY5JdAkqWQvO/oMO0yBJ4yYp+AVBhzfAojk/4bTQQbZr5w==",
    //                                     @"_ga":@"GA1.3.1383344522.1430472611"};
    config.HTTPAdditionalHeaders = @{@"SharedKey myaccount":@"EdUlm1oXs5hd6GnQMdDz6TjfivZmuIqR6z1qXQJasY5JdAkqWQvO/oMO0yBJ4yYp+AVBhzfAojk/4bTQQbZr5w=="};
    
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:blobURL];
    [request setHTTPMethod:@"PUT"];
    [request setValue:@"multipart/form-data" forHTTPHeaderField:@"Content-Type"];
    
    self.uploadTask = [upLoadSession uploadTaskWithRequest:request fromData:imageData];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    [_uploadTask resume];
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
}
#pragma mark - Utils

-(void)saveMyNew:(id)sender{
    self.model = [[YWCNewsModel alloc]initWithTitleNew:self.titleNewTextField.text
                                               textNew:self.textNew.text
                                              stateNew:@"noPublic"
                                                rating:0
                                              imageURL:@""
                                                author:self.userProfile
                                              latitude:0.0f
                                             longitude:0.0f
                                               address:@"Una calle"];
    MSTable *table = [[MSTable alloc]initWithName:@"news" client:self.client];
    
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

-(void)pop{

}
@end
