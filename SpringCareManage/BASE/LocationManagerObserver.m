//
//  LocationManagerObserver.m
//  SpringCare
//
//  Created by LiuZach on 15/4/13.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "LocationManagerObserver.h"
#import <AVOSCloud/AVOSCloud.h>
#import "define.h"
#import "UserModel.h"


@implementation LocationManagerObserver

@synthesize locationManager;


+ (LocationManagerObserver *)sharedInstance
{
    static dispatch_once_t once;
    static LocationManagerObserver *instance = nil;
    dispatch_once( &once, ^{
        instance = [[LocationManagerObserver alloc] init]; } );
    return instance;
}

- (id)init
{
    NSLog(@"[%@] init:", NSStringFromClass([self class]));
    
    if (self = [super init]) {
        geocoder = [[CLGeocoder alloc] init];
        locationManager = [[CLLocationManager alloc] init];//创建位置管理器
        locationManager.delegate=(id)self;
        locationManager.desiredAccuracy=kCLLocationAccuracyBest;
        locationManager.distanceFilter=100.0f;

    }
    
    return self;
}
- (void) startUpdateLocation {
    //启动位置更新
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        [self.locationManager requestWhenInUseAuthorization];
    }
      [self.locationManager startUpdatingLocation];
       // NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//        dispatch_async(dispatch_get_main_queue(), ^{
//        [self performSelector:@selector(hackLocationFix) withObject:nil afterDelay:0.1];
//        });
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    NSLog(@"didChangeAuthorizationStatus---%u",status);
    if (kCLAuthorizationStatusDenied == status || kCLAuthorizationStatusRestricted == status) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请在设置［隐私］里打开" message:@"定位服务已经关闭" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
         [alert show];
     }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    NSLog(@"didChangeAuthorizationStatus----%@",error);
}


-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    _lat = newLocation.coordinate.latitude;
    _lon = newLocation.coordinate.longitude;
        [geocoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *placemarks, NSError *error) {
            if([placemarks count] > 0){
                CLPlacemark *placemark = [placemarks objectAtIndex:0];
                 _currentCity= !placemark.locality?placemark.administrativeArea:placemark.locality;
                 _currentDetailAdrress =[NSString stringWithFormat:@"%@%@%@%@%@%@", placemark.administrativeArea,
                  !placemark.subAdministrativeArea?@"":placemark.subAdministrativeArea,
                  !placemark.locality?@"":placemark.locality,
                  !placemark.subLocality?@"":placemark.subLocality,
                  !placemark.thoroughfare?@"":placemark.thoroughfare,
                  !placemark.subThoroughfare?@"":placemark.subThoroughfare];
                
                
            // 更新当前用户坐标到服务器
                if ([AVUser currentUser]!=nil) {
                    AVUser *user = [AVUser currentUser];
                    AVGeoPoint *point = [AVGeoPoint geoPointWithLatitude:_lat longitude:_lon];
                    [user setObject:point forKey:@"locationPoint"];
                    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    if (succeeded) {
                            [[UserModel sharedUserInfo] modifyLocation:_currentDetailAdrress];
                        }
                    }];
                }
            }
        }];
    [manager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region
{
    NSLog(@"[%@] locationManager:didEnterRegion:%@ at %@", NSStringFromClass([self class]), region.identifier, [NSDate date]);
    
  }


- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region
{
    NSLog(@"[%@] locationManager:didExitRegion:%@ at %@", NSStringFromClass([self class]), region.identifier, [NSDate date]);
    
   }
@end
