//
//  YWCNewsModel.m
//  scoopNews
//
//  Created by Carmelo Ruymán Quintana Santana on 29/4/15.
//  Copyright (c) 2015 Carmelo Ruymán Quintana Santana. All rights reserved.
//

#import "YWCNewsModel.h"
#import "YWCProfile.h"
#import "YWClocationModel.h"
#import "services.h"
#import "Utils.h"
@implementation YWCNewsModel
+(NSArray *)observableKeyNames{
    return @[@"image"];
}
-(id)initWithTitleNew:(NSString *)title
              textNew:(NSString *)textNew
             stateNew:(NSString *)stateNew
               rating:(double)rating
             imageURL:(NSString *)imageURL
               author:(YWCProfile *)author
             location:(YWClocationModel *)location
         creationDate:(NSString *)creationDate
               client:(MSClient *)client
                image:(UIImage *)image{
    if (self = [super init]) {
        _titleNew = title;
        _textNew = textNew;
        _stateNew = stateNew;
        _rating = rating;
        _imageURL = imageURL;
        _author = author;
        _location = location;
        _creationDate = creationDate;
        _client = client;
        _image = image;
    }
    return self;
}
+(YWCNewsModel *)modelWithDictionary:(NSDictionary *)item client:(MSClient *)client{
    YWCProfile *author = [[YWCProfile alloc]initWithName:item[@"author"]
                                                  idUser:@""
                                                imageURL:item[@"imageAuthor"]];
    
    YWClocationModel *loc = [[YWClocationModel alloc]initWithLatitude:[[NSString stringWithFormat:@"%@",item[@"latitude"]] doubleValue]
                                                            longitude:[[NSString stringWithFormat:@"%@",item[@"longitude"]] doubleValue]
                                                              address:item[@"address"]];
    
    YWCNewsModel * new = [[YWCNewsModel alloc]initWithTitleNew:item[@"title"]
                                                       textNew:item[@"text"]
                                                      stateNew:item[@"stateNew"]
                                                        rating:[[NSString stringWithFormat:@"%@",item[@"rating"]] intValue]
                                                      imageURL:item[@"imageURL"]
                                                        author:author
                                                      location:loc
                                                  creationDate:item[@"creationDate"]
                                                        client:client
                                                         image:nil];
    new.idNews = item[@"id"];
    new.numberOfVotes = [[NSString stringWithFormat:@"%@",item[@"numberofvotes"]] intValue];
    
    return new;
    
    
}

+(NSDictionary *)dictionaryWithModel:(YWCNewsModel *)model{
    NSDictionary *dict= @{@"title":model.titleNew,
                          @"text":model.textNew,
                          @"stateNew":model.stateNew,
                          @"imageURL":model.imageURL,
                          @"author":model.author.nameUser,
                          @"imageAuthor":model.author.imageURL,
                          @"rating":@(model.rating),
                          @"latitude":[NSString stringWithFormat:@"%f",model.location.latitude],
                          @"longitude":[NSString stringWithFormat:@"%f",model.location.longitude],
                          @"address":model.location.address,
                          @"creationDate":model.creationDate,
                          @"numberofvotes":@0};
    return dict;
}
-(void)downloadImageWithURL:(NSURL *)sasURL {
    
    [services downloadDataWithURL:sasURL
              statusOperationWith:^(NSData *data,
                                    NSURLResponse *response,
                                    NSError *error) {
                  
                  dispatch_async(dispatch_get_main_queue(), ^{
                      self.image = [UIImage imageWithData:data];
                      
                      
                  });
                  
              } failure:^(NSURLResponse *response, NSError *error) {
                  
                  dispatch_async(dispatch_get_main_queue(), ^{
                      self.image = nil;
                  });
                  
              }];
    
}
- (void)handleSaSURLToDownload:(NSURL *)theUrl{
    
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:theUrl];
    
    [request setHTTPMethod:@"GET"];
    [request setValue:@"image/jpeg" forHTTPHeaderField:@"Content-Type"];
    
    NSURLSessionDownloadTask * downloadTask = [[NSURLSession sharedSession]downloadTaskWithRequest:request completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
        
        if (!error) {
            
            NSLog(@"resultado --> %@", response);
            NSData * data =[NSData dataWithContentsOfURL:location];
            UIImage *image = [UIImage imageWithData:data];
            self.image = image;
            [Utils saveWithData:data name:self.imageURL andDirectory:NSCachesDirectory];
        }
        
        
    }];
    [downloadTask resume];
    
}
-(void)getSasImage{
    
    
    
    if (self.imageURL != nil && self.imageURL.length > 0) {
        
        NSData * data = [Utils dataWithNameFile:self.imageURL andDirectory:NSCachesDirectory];
        if (data != nil) {
            self.image = [UIImage imageWithData:data];
        }else{
            NSString *permissions = @"r";
            NSString *nameResource = self.imageURL;
            NSDictionary *item = @{@"containerName":@"news",
                                   @"resourceName":nameResource};
            
            NSDictionary *params = @{@"blobName":nameResource,
                                     @"item":item,
                                     @"permissions":permissions};
            
            [self.client invokeAPI:@"geturlblob"
                              body:nil
                        HTTPMethod:@"get"
                        parameters:params
                           headers:nil
                        completion:^(id result, NSHTTPURLResponse *response, NSError *error) {
                            if (!error) {
                                NSURL *url = [NSURL URLWithString:[result valueForKey:@"sasUrl"]];
                                [self handleSaSURLToDownload:url];
                            }
                        }];
        }
    }
}

-(void)setupKVO:(id)object{
    NSArray * arr = [YWCNewsModel observableKeyNames];
    for (NSString *key in arr) {
        [self addObserver:object
               forKeyPath:key
                  options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                  context:NULL];
    }
}
-(void)tearDownKVO:(id)object{
    if (self.observationInfo !=nil) {
        NSArray * arr = [YWCNewsModel observableKeyNames];
        for (NSString *key in arr) {
            [self removeObserver:object forKeyPath:key];
        }
    }
}

@end
