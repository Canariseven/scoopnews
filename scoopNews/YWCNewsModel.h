//
//  YWCNewsModel.h
//  scoopNews
//
//  Created by Carmelo Ruymán Quintana Santana on 29/4/15.
//  Copyright (c) 2015 Carmelo Ruymán Quintana Santana. All rights reserved.
//


@import Foundation;
@import UIKit;
@class YWCProfile;
@interface YWCNewsModel : NSObject
@property (nonatomic, copy) NSString *titleNew;
@property (nonatomic, copy) NSString *textNew;
@property (nonatomic, copy) NSString *stateNew;
@property (nonatomic) int rating;
@property (nonatomic, copy) NSString *imageURL;
@property (nonatomic, strong) YWCProfile *author;
@property (nonatomic) double latitude;
@property (nonatomic) double longitude;
@property (nonatomic, copy) NSString * address;

+(YWCNewsModel *)modelWithDictionary:(NSDictionary *)item;
+(NSDictionary *)dictionaryWithModel:(YWCNewsModel *)model;
-(id)initWithTitleNew:(NSString *)title
              textNew:(NSString *)textNew
             stateNew:(NSString *)stateNew
               rating:(int)rating
             imageURL:(NSString *)imageURL
               author:(YWCProfile *)author
             latitude:(double)latitude
            longitude:(double)longitude
              address:(NSString *)address;


@end
