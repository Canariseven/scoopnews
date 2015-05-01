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
               author:(YWCProfile *)author
             latitude:(double)latitude
            longitude:(double)longitude
              address:(NSString *)address{
    if (self = [super init]) {
        _titleNew = title;
        _textNew = textNew;
        _stateNew = stateNew;
        _rating = rating;
        _imageURL = imageURL;
        _author = author;
        _latitude = latitude;
        _longitude = longitude;
        _address = address;
    }
    return self;
}
+(YWCNewsModel *)modelWithDictionary:(NSDictionary *)item{
    YWCNewsModel * new = [[YWCNewsModel alloc]initWithTitleNew:item[@"title"]
                                                       textNew:item[@"text"]
                                                      stateNew:item[@"stateNew"]
                                                        rating:4 imageURL:@""
                                                        author:item[@"author"]
                                                      latitude:[[NSString stringWithFormat:@"%@",item[@"latitude"]] intValue]
                                                     longitude:[[NSString stringWithFormat:@"%@",item[@"longitude"]] intValue]
                                                       address:item[@"address"]];
    return new;


}

@end
