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
    [self tearDownKVO];
}

-(void)sincronizeView{
    self.titleNew.text = self.model.titleNew;
    self.authorNew.text = self.model.author.nameUser;
    self.image.image = self.model.image;
        [self setupKVO];

}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setupKVO{


        [self.model addObserver:self
                           forKeyPath:@"image"
                              options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                              context:NULL];
    
}
-(void)tearDownKVO{
    if (self.model.observationInfo != nil) {
        [self.model removeObserver:self
                        forKeyPath:@"image"];
    }

    
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
    [self tearDownKVO];
    self.image.image = nil;
    self.titleNew.text = nil;
    self.authorNew.text = nil;
}

@end
