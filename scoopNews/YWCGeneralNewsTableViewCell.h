//
//  YWCGeneralNewsTableViewCell.h
//  scoopNews
//
//  Created by Carmelo Ruymán Quintana Santana on 29/4/15.
//  Copyright (c) 2015 Carmelo Ruymán Quintana Santana. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YWCGeneralNewsTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *titleNew;
@property (weak, nonatomic) IBOutlet UILabel *authorNew;

@end
