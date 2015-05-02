//
//  YWCLibraryNews.h
//  scoopNews
//
//  Created by Carmelo Ruymán Quintana Santana on 29/4/15.
//  Copyright (c) 2015 Carmelo Ruymán Quintana Santana. All rights reserved.
//

@import Foundation;
@import UIKit;
@class YWCProfile;
@class YWCNewsModel;
#import <WindowsAzureMobileServices/WindowsAzureMobileServices.h>
@class YWCLibraryNews;
@protocol YWCLibraryNewsDelegate <NSObject>

-(void)libraryNews:(YWCLibraryNews *)libraryNews;

@end



@interface YWCLibraryNews : NSObject
@property (nonatomic, strong) YWCProfile *user;
@property (nonatomic, strong) YWCNewsModel *newsModel;
@property (nonatomic, strong) NSMutableArray *allNews;
@property (nonatomic, strong) NSMutableArray *myNews;
@property (nonatomic, readonly) NSUInteger allNewsCount;
@property (nonatomic, readonly) NSUInteger myNewsCount;
@property (nonatomic, weak) id<YWCLibraryNewsDelegate> delegate;
@property (nonatomic, strong) MSClient *client;
-(id)initWithUser:(YWCProfile *)user;

-(YWCNewsModel *)newFromAllNewsAtIndexPath:(NSIndexPath *)indexPath;
-(YWCNewsModel *)newFromMyNewsAtIndexPath:(NSIndexPath *)indexPath;
-(void)getAllNewsFromAzureWithClient:(MSClient *)client andTable:(MSTable *)table;
-(void)getMyNewsFromAzureWithClient:(MSClient *)client andTable:(MSTable *)table;

@end
