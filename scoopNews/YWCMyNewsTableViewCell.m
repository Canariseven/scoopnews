//
//  YWCMyNewsTableViewCell.m
//  scoopNews
//
//  Created by Carmelo Ruymán Quintana Santana on 29/4/15.
//  Copyright (c) 2015 Carmelo Ruymán Quintana Santana. All rights reserved.
//

#import "YWCMyNewsTableViewCell.h"
#import "YWCNewsModel.h"

@implementation YWCMyNewsTableViewCell

- (void)awakeFromNib {
    // Initialization code
}
-(void)sincronizeView{
    self.titleNew.text = self.model.titleNew;
    
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)Public:(id)sender {
}


@end
