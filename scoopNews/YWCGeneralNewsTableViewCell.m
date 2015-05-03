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

-(void)dealloc{
    [self.model tearDownKVO:self];
}

-(void)sincronizeView{
    if (self.model.numberOfVotes == 0) {
        self.ratingLabel.text = @"0";
    }else{
        self.ratingLabel.text = [NSString stringWithFormat:@"%.2f",self.model.rating/self.model.numberOfVotes ];
    }
    
    self.titleNew.text = self.model.titleNew;
    self.authorNew.text = self.model.author.nameUser;
    self.image.image = self.model.image;
    [self.model setupKVO:self];

}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)observeValueForKeyPath:(NSString *)keyPath
                     ofObject:(id)object
                       change:(NSDictionary *)change
                      context:(void *)context{
        dispatch_async(dispatch_get_main_queue(), ^{
            self.image.image = self.model.image;
        });
    
}

-(void) prepareForReuse{
    [super prepareForReuse];
    // hacemos limpieza
    [self cleanUp];
}

-(void) cleanUp{
    [self.model tearDownKVO:self];
    self.image.image = nil;
    self.titleNew.text = nil;
    self.authorNew.text = nil;
}

@end
