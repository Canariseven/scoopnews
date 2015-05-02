//
//  ViewController.h
//  scoopNews
//
//  Created by Carmelo Ruymán Quintana Santana on 29/4/15.
//  Copyright (c) 2015 Carmelo Ruymán Quintana Santana. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WindowsAzureMobileServices/WindowsAzureMobileServices.h>
@interface YWCViewController : UIViewController
- (IBAction)loginButton:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageProfile;

@property (weak, nonatomic) IBOutlet UIButton *myNewsButton;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIView *contentImageView;
-(id)initWithClient:(MSClient *)client andTable:(MSTable *)table;
@end

