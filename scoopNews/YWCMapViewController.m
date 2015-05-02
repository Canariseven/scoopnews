//
//  YWCMapViewController.m
//  scoopNews
//
//  Created by Carmelo Ruymán Quintana Santana on 2/5/15.
//  Copyright (c) 2015 Carmelo Ruymán Quintana Santana. All rights reserved.
//

#import "YWCMapViewController.h"
#import "YWCLocationModel.h"
#import "YWCNewsModel.h"
@import CoreLocation;
@import AddressBookUI;
@interface YWCMapViewController ()< MKMapViewDelegate>

@end

@implementation YWCMapViewController


-(id)initWithNewModelLocation:(YWClocationModel *)model{
    if (self = [super initWithNibName:nil bundle:nil]) {
        _location = model;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.map.delegate = self;
    MKCoordinateRegion big;
    if (self.location.latitude != 0.0f) {
        [self.map addAnnotation:self.location];
        big = MKCoordinateRegionMakeWithDistance(self.location.coordinate, 2000000, 2000000);
        [self.map setRegion:big];
        
    }else{
        CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(34.9385936,-7.7355026);
        big = MKCoordinateRegionMakeWithDistance(coord, 5000000, 5000000);
        [self.map setRegion:big];
        
    }
    [self addLongPick];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];

}

-(void)addLongPick{
    UILongPressGestureRecognizer *longGT = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressGestureOnMap:)];
    longGT.minimumPressDuration = 1.0;
    [self.map addGestureRecognizer:longGT];
}
-(void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (self.location.latitude != 0.0f) {
        MKCoordinateRegion small = MKCoordinateRegionMakeWithDistance(self.location.coordinate, 500, 500);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.map
             setRegion:small animated:YES];
        });
    }
}
-(void)longPressGestureOnMap:(UILongPressGestureRecognizer *)gestureRecognizer{
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        CGPoint point = [gestureRecognizer locationInView:self.map];
        CLLocationCoordinate2D coord =     [self.map convertPoint:point toCoordinateFromView:self.map];
        CLLocation *location = [[CLLocation alloc]initWithLatitude:coord.latitude longitude:coord.longitude];
        [self setAddressWithLocation:location toModelLocation:self.location];
        self.location.latitude = coord.latitude;
        self.location.longitude = coord.longitude;
        [self.map removeAnnotations:self.map.annotations];
        [self.map addAnnotation:self.location];
    }
}

-(void)setAddressWithLocation:(CLLocation *)location toModelLocation:(YWClocationModel *)locationModel{
    CLGeocoder *coder = [[CLGeocoder alloc]init];
    [coder reverseGeocodeLocation:location
                completionHandler:^(NSArray *placemarks, NSError *error) {
                    if (error) {
                        NSLog(@"Error while obtaining address!\n%@", error);
                    }else{
                        locationModel.address = ABCreateStringWithAddressDictionary([[placemarks lastObject] addressDictionary], YES);
                    }
                }];
}



@end
