//
//  CLController.h
//  LiteGPS
//
//  Created by Adam Hardtke on 10/22/12.
//  Copyright (c) 2012 Adam Hardtke. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CLControllerDelegate
@required
- (void)locationUpdate:(CLLocation *)location;
- (void)locationError:(NSError *)error;
@end

@interface CLController : NSObject <CLLocationManagerDelegate> {
    CLLocationManager *locationManager;
    id delegate;
}

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, weak) id delegate;

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation;
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error;

@end
