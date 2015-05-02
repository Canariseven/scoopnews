//
//  YWCProfile.h
//  scoopNews
//
//  Created by Carmelo Ruymán Quintana Santana on 29/4/15.
//  Copyright (c) 2015 Carmelo Ruymán Quintana Santana. All rights reserved.
//

@import Foundation;
@import UIKit;
#import <WindowsAzureMobileServices/WindowsAzureMobileServices.h>
@interface YWCProfile : NSObject
@property (nonatomic, copy) NSString *nameUser;
@property (nonatomic, copy) NSString *idUser;
@property (nonatomic, copy) NSString *imageURL;
@property (nonatomic, copy) NSString *token;
@property (nonatomic, strong) MSClient *client;
@property (nonatomic, strong) UIImage *image;
-(NSArray *)observableKeyNames;

-(id)initWithName:(NSString *)nameUser
           idUser:(NSString *)idUser
          imageURL:(NSString *)imageURL;

-(id)initWithClient:(MSClient *) client;
-(BOOL)loadUserAuthInfo;
-(void)saveAuthInfo;
-(void)getUserInfo;
-(void)deleteUserOnDefault;
-(void)downloadImage;
@end
