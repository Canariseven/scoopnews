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

-(void)sincronizeView{
    self.titleNew.text = self.model.titleNew;
    if (self.model.numberOfVotes == 0) {
        self.ratingLabel.text = @"0";
    }else{
        self.ratingLabel.text = [NSString stringWithFormat:@"%f.0",self.model.rating/self.model.numberOfVotes ];
    }
    
    self.image.image = self.model.image;
    [self setupKVO];
}

- (void)awakeFromNib {
    // Initialization code
    
}
-(void)dealloc{
    [self tearDownKVO];
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
    self.ratingLabel.text = nil;
}
@end
