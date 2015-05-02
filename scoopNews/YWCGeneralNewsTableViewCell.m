//
//  YWCGeneralNewsTableViewCell.m
//  scoopNews
//
//  Created by Carmelo Ruymán Quintana Santana on 29/4/15.
//  Copyright (c) 2015 Carmelo Ruymán Quintana Santana. All rights reserved.
//

#import "YWCGeneralNewsTableViewCell.h"
#import "YWCNewsModel.h"
#import "YWCProfile.h"
@implementation YWCGeneralNewsTableViewCell

- (void)awakeFromNib {
    // Initialization code
}
-(void)sincronizeView{
    self.titleNew.text = self.model.titleNew;
    self.authorNew.text = self.model.author.nameUser;

}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
