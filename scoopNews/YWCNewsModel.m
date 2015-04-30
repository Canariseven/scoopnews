//
//  YWCNewsModel.m
//  scoopNews
//
//  Created by Carmelo Ruymán Quintana Santana on 29/4/15.
//  Copyright (c) 2015 Carmelo Ruymán Quintana Santana. All rights reserved.
//

#import "YWCNewsModel.h"
#import "YWCProfile.h"
@implementation YWCNewsModel
-(id)initWithTitleNew:(NSString *)title
              textNew:(NSString *)textNew
             stateNew:(NSString *)stateNew
               rating:(int)rating
             imageURL:(NSString *)imageURL
               author:(YWCProfile *)author{
    if (self = [super init]) {
        _titleNew = title;
        _textNew = textNew;
        _stateNew = stateNew;
        _rating = rating;
        _imageURL = imageURL;
        _author = author;
    }
    return self;
}

@end
