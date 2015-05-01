//
//  YWCNewsTableViewController.h
//  scoopNews
//
//  Created by Carmelo Ruymán Quintana Santana on 29/4/15.
//  Copyright (c) 2015 Carmelo Ruymán Quintana Santana. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WindowsAzureMobileServices/WindowsAzureMobileServices.h>
#import "YWCLibraryNews.h"
@class YWCNewsTableViewController;
//@protocol YWCnewsTableViewControllerDelegate <NSObject>
//
//-(void)newsTableViewController:(YWCNewsTableViewController *)aNewsVC;
//
//@end


@interface YWCNewsTableViewController : UIViewController<YWCLibraryNewsDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
//@property (weak, nonatomic) id<YWCnewsTableViewControllerDelegate> delegate;
-(id)initWithAllNews:(YWCLibraryNews *)arrayModel withClient:(MSClient *)client andTable:(MSTable *)table mode:(NSString *)mode;
@end
