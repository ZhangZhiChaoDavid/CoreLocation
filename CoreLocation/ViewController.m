//
//  ViewController.m
//  CoreLocation
//
//  Created by 张智超 on 2017/3/16.
//  Copyright © 2017年 GeezerChao. All rights reserved.
//

#import "ViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface ViewController ()<CLLocationManagerDelegate>
{
    CLLocationManager *_locationManager;
}

@end

@implementation ViewController

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createLocation];
}

-(void)createLocation{
    
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    NSLog(@"---%d---",status);
    if (status==kCLAuthorizationStatusAuthorizedAlways || status==kCLAuthorizationStatusAuthorizedWhenInUse || status==kCLAuthorizationStatusNotDetermined) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        
        _locationManager.activityType = CLActivityTypeOther;
        /*
         CLActivityTypeOther = 1,（定位数据作为普通用途）
         CLActivityTypeAutomotiveNavigation,（定位数据作为车辆导航使用）
         CLActivityTypeFitness,（定位数据作为步行导航使用）
         CLActivityTypeOtherNavigation（定位数据作为其他导航使用）
         */
        // 定位距离
        _locationManager.distanceFilter = 10;
        
        [_locationManager setDesiredAccuracy:kCLLocationAccuracyBestForNavigation];
        /*
         kCLLocationAccuracyBestForNavigation;（导航级的最佳精确度）
         kCLLocationAccuracyBest;（最佳精确度）
         kCLLocationAccuracyNearestTenMeters;（10米误差）；
         kCLLocationAccuracyHundredMeters;（百米误差）
         kCLLocationAccuracyKilometer;（千米误差）
         kCLLocationAccuracyThreeKilometers;（三千米误差）
         */
        
        if([[[UIDevice currentDevice]systemVersion]floatValue] >= 8.0) {
            
            
            if (status==kCLAuthorizationStatusAuthorizedAlways) {
                [_locationManager requestWhenInUseAuthorization];
            }
            else if (status==kCLAuthorizationStatusAuthorizedWhenInUse) {
                [_locationManager requestAlwaysAuthorization];
            }
            else if (status==kCLAuthorizationStatusNotDetermined) {
                if([_locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
                    [_locationManager requestAlwaysAuthorization];
                }
            }
            else {
                return;
            }
            // 如果在iOS9.0+想要在前台授权模式下, 在后台获取用户位置, 我们需要额外的设置以下属性为YES
            if ([[[UIDevice currentDevice]systemVersion]floatValue] >= 9.0) {
                _locationManager.allowsBackgroundLocationUpdates = NO;
            }
        }
        
        // pausesLocationUpdatesAutomatically：设置iOS设备是否可暂停定位来节省电池的电量。如果该属性设为“YES”，则当iOS设备不再需要定位数据时，iOS设备可以自动暂停定位
        _locationManager.pausesLocationUpdatesAutomatically = YES;
        
        [_locationManager startUpdatingLocation];
        [_locationManager startUpdatingHeading];
    }
}


#pragma mark - CLLoactionManagerDelegate

// 成功获取定位数据后就会激发该方法;locations最后一个为最新的
- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray<CLLocation *> *)locations {
    
    CLLocation *curLocation = locations.lastObject;
    NSLog(@"%@",curLocation);
}

// 成功获取设备方向数据后就会激发该方法
- (void)locationManager:(CLLocationManager *)manager
       didUpdateHeading:(CLHeading *)newHeading {
    
    NSLog(@"%@",newHeading);
}

// 是否显示方向刻度
- (BOOL)locationManagerShouldDisplayHeadingCalibration:(CLLocationManager *)manager  {
    
    return YES;
}

// 定位失败时
- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error {
    
    
}

// 授权状态发生改变
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    
    
}

// 暂停了定位数据获取
- (void)locationManagerDidPauseLocationUpdates:(CLLocationManager *)manager {
    
    
}

// 恢复了定位数据的获取
- (void)locationManagerDidResumeLocationUpdates:(CLLocationManager *)manager {
    
    
}



@end
