//
//  YWCProfile.m
//  scoopNews
//
//  Created by Carmelo Ruymán Quintana Santana on 29/4/15.
//  Copyright (c) 2015 Carmelo Ruymán Quintana Santana. All rights reserved.
//

#import "YWCProfile.h"
#import <WindowsAzureMobileServices/WindowsAzureMobileServices.h>
#import "services.h"
@implementation YWCProfile
-(NSArray *)observableKeyNames{
    return @[@"nameUser",@"image"];
}


-(void)downloadImage{
    if (self.imageURL != nil) {
        NSURL *url = [NSURL URLWithString:self.imageURL];
        [services downloadDataWithURL:url
                  statusOperationWith:^(NSData *data, NSURLResponse *response, NSError *error) {
                      dispatch_async(dispatch_get_main_queue(), ^{
                          self.image = [UIImage imageWithData:data];
                      });
                  } failure:^(NSURLResponse *response, NSError *error) {
                      dispatch_async(dispatch_get_main_queue(), ^{
                          self.image = nil;
                      });
                  }];
    }else{
        self.image = nil;
    }
}

-(id)initWithName:(NSString *)nameUser
           idUser:(NSString *)idUser
         imageURL:(NSString *)imageURL{
    if (self = [super init]) {
        _nameUser = nameUser;
        _idUser = idUser;
        _imageURL = imageURL;
    }
    return self;
}

-(id)initWithClient:(MSClient *) client{
    if (self = [super init]) {
        _client = client;
    }
    return self;
}


- (BOOL)loadUserAuthInfo{
    
    self.idUser = [[NSUserDefaults standardUserDefaults]objectForKey:@"userID"];
    self.token = [[NSUserDefaults standardUserDefaults]objectForKey:@"tokenFB"];
    
    if (self.idUser) {
        self.client.currentUser = [[MSUser alloc]initWithUserId:self.idUser];
        self.client.currentUser.mobileServiceAuthenticationToken = [[NSUserDefaults standardUserDefaults]objectForKey:@"tokenFB"];
        return TRUE;
    }
    
    return FALSE;
}


- (void) saveAuthInfo{
    [[NSUserDefaults standardUserDefaults]setObject:self.client.currentUser.userId forKey:@"userID"];
    [[NSUserDefaults standardUserDefaults]setObject:self.client.currentUser.mobileServiceAuthenticationToken
                                             forKey:@"tokenFB"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
}
-(void)getUserInfo{
    
    [self.client invokeAPI:@"getcurrentuserinfo" body:nil HTTPMethod:@"GET" parameters:nil headers:nil completion:^(id result, NSHTTPURLResponse *response, NSError *error) {
        // p.e: obtenemos la url de la foto de perfil
        self.imageURL = result[@"picture"][@"data"][@"url"];
        self.nameUser = result[@"name"];
        [self downloadImage];
    }];
}
-(void)deleteUserOnDefault{
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"userID"];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"tokenFB"];
}

@end
