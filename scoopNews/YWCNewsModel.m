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

@implementation YWCNewsModel
-(id)initWithTitleNew:(NSString *)title
              textNew:(NSString *)textNew
             stateNew:(NSString *)stateNew
               rating:(double)rating
             imageURL:(NSString *)imageURL
               author:(YWCProfile *)author
             location:(YWClocationModel *)location
         creationDate:(NSString *)creationDate{
    if (self = [super init]) {
        _titleNew = title;
        _textNew = textNew;
        _stateNew = stateNew;
        _rating = rating;
        _imageURL = imageURL;
        _author = author;
        _location = location;
        _creationDate = creationDate;
    }
    return self;
}
+(YWCNewsModel *)modelWithDictionary:(NSDictionary *)item{
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
                                                      imageURL:@""
                                                        author:author
                                                      location:loc
                                                  creationDate:item[@"creationDate"]];
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
                          @"creationDate":model.creationDate};
    return dict;
}

@end
