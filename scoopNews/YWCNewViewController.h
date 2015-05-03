//
//  YWCNewViewController.h
//  scoopNews
//
//  Created by Carmelo Ruymán Quintana Santana on 29/4/15.
//  Copyright (c) 2015 Carmelo Ruymán Quintana Santana. All rights reserved.
//

#import "GAITrackedViewController.h"
#import <WindowsAzureMobileServices/WindowsAzureMobileServices.h>
#import <UIKit/UIKit.h>
@import Foundation;
@class YWCProfile;
@class YWCLibraryNews;
@class YWCNewsModel;
@interface YWCNewViewController : GAITrackedViewController
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UITextView *textNew;
@property (weak, nonatomic) IBOutlet UIView *middleView;
@property (weak, nonatomic) IBOutlet UITextField *titleNewTextField;
@property (weak, nonatomic) IBOutlet UIImageView *profilePhoto;
@property (weak, nonatomic) IBOutlet UIView *contentViewImageProfile;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentValorator;
@property (weak, nonatomic) IBOutlet UILabel *authorName;
@property (weak, nonatomic) IBOutlet UILabel *dateNew;
@property (weak, nonatomic) IBOutlet UIButton *locationButton;
@property (weak, nonatomic) IBOutlet UIButton *voteButton;
@property (weak, nonatomic) IBOutlet UIButton *publishButton;
- (IBAction)publiButton:(id)sender;
- (IBAction)locationButton:(id)sender;
-(id)initWithlibrary:(YWCLibraryNews *)library;
-(id)initWithNewsModel:(YWCNewsModel *)newsModel;

@end
