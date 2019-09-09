//
//  FTLocationManager.m
//  FTTemplate
//
//  Created by 史超 on 2018/11/22.
//  Copyright © 2018年 史超. All rights reserved.
//

#import "FTLocationManager.h"
#import <CoreLocation/CoreLocation.h>
#import "FTCommonMacro.h"

@interface FTLocationManager()<CLLocationManagerDelegate>
@property (nonatomic, strong) CLLocationManager * locManager;
@property (nonatomic, copy) LocationBlock block;
@end

@implementation FTLocationManager

+ (instancetype)sharedManager {
    static FTLocationManager * _manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [[FTLocationManager alloc] init];
    });
    return _manager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _locManager = [[CLLocationManager alloc] init];
        [_locManager setDesiredAccuracy:kCLLocationAccuracyBest];
        _locManager.distanceFilter = 100;
        _locManager.delegate = self;
        if (![CLLocationManager locationServicesEnabled]) {
            NSLog(@"请开启定位服务");
        } else {
            CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
            if (status == kCLAuthorizationStatusNotDetermined) {
                [_locManager requestWhenInUseAuthorization];
            }
        }
    }
    return self;
}

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation {
    
    CLLocationCoordinate2D coor = newLocation.coordinate;
   __block NSString * latString = [NSString stringWithFormat:@"%.6f",coor.longitude];
   __block NSString * lonString = [NSString stringWithFormat:@"%.6f",coor.latitude];
    
    __weak typeof(self) weakSelf = self;
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    //根据经纬度反向地理编译出地址信息
    [geocoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *array, NSError *error)
     {
         if (array.count > 0) {
             CLPlacemark *placemark = [array objectAtIndex:0];
             //获取城市
             NSString *city = placemark.locality;
             if (!city) {
                 //四大直辖市的城市信息无法通过locality获得，只能通过获取省份的方法来获得（如果city为空，则可知为直辖市）
                 city = placemark.administrativeArea;
             }
             
                 weakSelf.lon = lonString;
                 weakSelf.lat = latString;
                 weakSelf.block(latString,lonString,[NSString stringWithFormat:@"%@",[(NSArray *)[placemark.addressDictionary objectForKey:@"FormattedAddressLines"] firstObject]]);
             
             NSLog(@"dic = %@",placemark.addressDictionary);
         } else if (error == nil && [array count] == 0) {
             NSLog(@"No results were returned.");
         } else if (error != nil) {
             NSLog(@"An error occurred = %@", error);
         }
     }];
    
    [self.locManager stopUpdatingLocation];
    
}

- (void)getLocation:(LocationBlock)block {
    self.block = block;
    [self.locManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {

    [manager stopUpdatingLocation];
    NSString *errorString;
    NSString *alterTitle;
    NSLog(@"Error: %@",[error localizedDescription]);
    switch([error code]) {
        case kCLErrorDenied:
            //Access denied by user
            errorString = @"请在系统设置中开启定位服务\n(设置>隐私>定位服务)";
            alterTitle  = @"定位服务未开启";
            break;
        case kCLErrorNetwork:
            //Probably temporary...
            errorString = @"网络未开启,请检查网络设置";
            alterTitle  = @"提示";
            break;
        default:
            errorString = @"发生位置错误";
            alterTitle  = @"提示";
            break;
    }

    UIAlertView *locationFailAlert = [[UIAlertView alloc] initWithTitle:alterTitle message:errorString delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
    [locationFailAlert show];
}

@end
