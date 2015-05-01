//
//  YWCLoginViewController.h
//  scoopNews
//
//  Created by Carmelo Ruymán Quintana Santana on 30/4/15.
//  Copyright (c) 2015 Carmelo Ruymán Quintana Santana. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WindowsAzureMobileServices/WindowsAzureMobileServices.h>
@class YWCProfile;
@interface YWCLoginViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIView *contentImageView;

@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (nonatomic, strong) YWCProfile *userProfile;
- (IBAction)loginButton:(id)sender;
-(id)initWithClient:(MSClient *)client andUser:(YWCProfile *)userProfile;
@end
