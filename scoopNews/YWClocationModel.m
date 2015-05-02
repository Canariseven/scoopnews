//
//  YWClocationModel.m
//  scoopNews
//
//  Created by Carmelo Ruymán Quintana Santana on 2/5/15.
//  Copyright (c) 2015 Carmelo Ruymán Quintana Santana. All rights reserved.
//

#import "YWClocationModel.h"
@import AddressBookUI;

@implementation YWClocationModel
@synthesize locationManager = _locationManager;
+(instancetype)locationWith:(CLLocation *)location{
    YWClocationModel *loc = [[YWClocationModel alloc]init];
    loc.latitude = location.coordinate.latitude;
    loc.longitude = location.coordinate.longitude;
    [self setAddressWithLocation:location toModelLocation:loc];
    return loc;
}
-(id)init{
   if (self = [super init]) {
       _latitude = 0;
       _longitude = 0;
       _address = @"";
       [self startLocation];
   }
    return self;
}
-(id)initWithLatitude:(double)latitude
            longitude:(double)longitude
              address:(NSString *)address{
    if (self = [super init]) {
        _latitude = latitude;
        _longitude = longitude;
        _address = address;
    }
    return self;
}
+(void)setAddressWithLocation:(CLLocation *)location toModelLocation:(YWClocationModel *)locationModel{
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
#pragma mark - MKAnnotation
-(NSString*) title{
    return @"I wrote a new here!";
}

-(NSString *) subtitle{
    NSArray *lines = [self.address componentsSeparatedByString:@"\n"];
    NSMutableString *concat = [@"" mutableCopy];
    for (NSString *line in lines) {
        [concat appendFormat:@"%@ ", line];
    }
    
    return concat;
}

-(CLLocationCoordinate2D)coordinate{
    
    CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(self.latitude, self.longitude);
    return coord;
}

-(void)startLocation{
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    if ( ((status == kCLAuthorizationStatusAuthorizedWhenInUse) || (status == kCLAuthorizationStatusNotDetermined))
        && [CLLocationManager locationServicesEnabled]) {
        
        // Tenemos acceso a localización
        self.locationManager = [[CLLocationManager alloc] init];
        [self.locationManager requestWhenInUseAuthorization];
        [self.locationManager requestAlwaysAuthorization];

        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        [self.locationManager startUpdatingLocation];
        
        // No me interesan datos pasado mucho tiempo, asi que si no
        // recibimos posición en menos de 5 segundos, paramos al
        // locationManager
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self zapLocationManager];
        });
    }
}
-(void)zapLocationManager{
    [self.locationManager stopUpdatingLocation];
    self.locationManager.delegate = nil;
    self.locationManager = nil;
}
@end
