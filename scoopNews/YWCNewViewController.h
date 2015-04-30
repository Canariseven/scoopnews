//
//  YWCNewViewController.h
//  scoopNews
//
//  Created by Carmelo Ruymán Quintana Santana on 29/4/15.
//  Copyright (c) 2015 Carmelo Ruymán Quintana Santana. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YWCNewViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UITextView *textNew;
@property (weak, nonatomic) IBOutlet UIView *middleView;
@property (weak, nonatomic) IBOutlet UIImageView *profilePhoto;
- (IBAction)publiButton:(id)sender;
- (IBAction)locationButton:(id)sender;

@end
