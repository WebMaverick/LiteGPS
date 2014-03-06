//
//  CLController.m
//  LiteGPS
//
//  Created by Adam Hardtke on 10/22/12.
//  Copyright (c) 2012 Adam Hardtke. All rights reserved.
//

#import "CLController.h"

@implementation CLController

@synthesize locationManager = _locationManager;
@synthesize delegate = _delegate;

- (id) init {
    self = [super init];
    if (self != nil) {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self; // send location updates to me
    }
    return self;
}

# pragma mark
# pragma Core Location
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
//    NSLog(@"Location: %@", [newLocation description]);
    [self.delegate locationUpdate:newLocation];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
//    NSLog(@"Error: %@", [error description]);
    [self.delegate locationError:error];
}


@end
