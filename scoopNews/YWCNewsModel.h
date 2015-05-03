//
//  YWCNewsModel.h
//  scoopNews
//
//  Created by Carmelo Ruymán Quintana Santana on 29/4/15.
//  Copyright (c) 2015 Carmelo Ruymán Quintana Santana. All rights reserved.
//

#import <WindowsAzureMobileServices/WindowsAzureMobileServices.h>
@import Foundation;
@import UIKit;
@class YWCProfile;
@class YWClocationModel;

@interface YWCNewsModel : NSObject
@property (nonatomic, copy) NSString *idNews;
@property (nonatomic, copy) NSString *titleNew;
@property (nonatomic, copy) NSString *textNew;
@property (nonatomic, copy) NSString *stateNew;
@property (nonatomic) double rating;
@property (nonatomic) double numberOfVotes;
@property (nonatomic, copy) NSString *imageURL;
@property (nonatomic, strong) YWCProfile *author;
@property (nonatomic, strong) YWClocationModel *location;
@property (nonatomic, strong) MSClient *client;
@property (nonatomic, strong) NSString *creationDate;
@property (nonatomic, strong) UIImage *image;

+(NSArray *)observableKeyNames;

+(YWCNewsModel *)modelWithDictionary:(NSDictionary *)item client:(MSClient *)client;
+(NSDictionary *)dictionaryWithModel:(YWCNewsModel *)model;
-(id)initWithTitleNew:(NSString *)title
              textNew:(NSString *)textNew
             stateNew:(NSString *)stateNew
               rating:(double)rating
             imageURL:(NSString *)imageURL
               author:(YWCProfile *)author
             location:(YWClocationModel *)location
         creationDate:(NSString *)creationDate
               client:(MSClient *)client
                image:(UIImage *)image;

-(void)getSasImage;
-(void)setupKVO:(id)object;
-(void)tearDownKVO:(id)object;
@end
