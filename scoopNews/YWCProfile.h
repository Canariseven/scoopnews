//
//  YWCProfile.h
//  scoopNews
//
//  Created by Carmelo Ruymán Quintana Santana on 29/4/15.
//  Copyright (c) 2015 Carmelo Ruymán Quintana Santana. All rights reserved.
//

@import Foundation;
@import UIKit;

@interface YWCProfile : NSObject
@property (nonatomic, copy) NSString *nameUser;
@property (nonatomic, copy) NSString *idUser;
@property (nonatomic, copy) NSString *imageURL;

-(id)initWithName:(NSString *)nameUser
           idUser:(NSString *)idUser
          imageURL:(NSString *)imageURL;
@end
