//
//  YWCProfile.m
//  scoopNews
//
//  Created by Carmelo Ruymán Quintana Santana on 29/4/15.
//  Copyright (c) 2015 Carmelo Ruymán Quintana Santana. All rights reserved.
//

#import "YWCProfile.h"

@implementation YWCProfile
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
@end
