//
//  YWCMapViewController.h
//  scoopNews
//
//  Created by Carmelo Ruymán Quintana Santana on 2/5/15.
//  Copyright (c) 2015 Carmelo Ruymán Quintana Santana. All rights reserved.
//

#import <UIKit/UIKit.h>
@import MapKit;
@class YWClocationModel;
@interface YWCMapViewController : UIViewController
@property (weak, nonatomic) IBOutlet MKMapView *map;
@property (nonatomic, strong) YWClocationModel *location;
-(id)initWithNewModelLocation:(YWClocationModel *)location;
@end
