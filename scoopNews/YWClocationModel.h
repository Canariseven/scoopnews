//
//  YWClocationModel.h
//  scoopNews
//
//  Created by Carmelo Ruymán Quintana Santana on 2/5/15.
//  Copyright (c) 2015 Carmelo Ruymán Quintana Santana. All rights reserved.
//

#import <Foundation/Foundation.h>
@import MapKit;
@import CoreLocation;
@class YWCNewsModel;

@interface YWClocationModel : NSObject<MKAnnotation>
@property (nonatomic) double latitude;
@property (nonatomic) double longitude;
@property (nonatomic, strong) NSString *address;
@property (nonatomic,strong) CLLocationManager *locationManager;
+(instancetype)locationWith:(CLLocation *)location;
+(void)setAddressWithLocation:(CLLocation *)location toModelLocation:(YWClocationModel *)locationModel;
-(id)initWithLatitude:(double)latitude
            longitude:(double)longitude
              address:(NSString *)address;
@end
