//
//  ViewController.m
//  LiteGPS
//
//  Created by Adam Hardtke on 10/19/12.
//  Copyright (c) 2012 Adam Hardtke. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
#import "TripViewController.h"
#import "Locations.h"
#import <math.h>

@interface ViewController ()
@end

@implementation ViewController

@synthesize appDelegate = _appDelegate;
@synthesize lat;
@synthesize lon;
@synthesize alt;
@synthesize speed;
@synthesize maxSpeed;
@synthesize dist;
@synthesize totalDist;
@synthesize idle;
@synthesize elapsed;
@synthesize progressView;
@synthesize button;

static double MPS_to_MPH = 2.23694;
static double METERS_to_FEET = 3.28084;

double maxSpeedCache = 0;
CLLocation *startPoint = nil;
CLLocation *prevPoint = nil;
double idleTime = 0;
double totalDistance = 0;
NSDate *lastIdleStart;

//NSDateFormatter *dateFormatter;

BOOL isActive = NO;
BOOL isIdle = NO;

# pragma mark
- (void)viewDidLoad {
    [super viewDidLoad];
    _appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [self initText];

    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)buttonClicked:(id)sender {
    if (!isActive) {
        [button setTitle:@"Stop" forState:UIControlStateNormal];
        startPoint = nil;
        maxSpeedCache = 0;
        idleTime = 0;
        totalDistance = 0;
        isIdle = NO;
        lastIdleStart = nil;
        startPoint = nil;
        isActive = YES;
        self.progressView.progress = 0;
        [_appDelegate incrementTripId];
        [self startGettingLocation];
    } else {
        [button setTitle:@"Start" forState:UIControlStateNormal];
        isActive = NO;
        [self stopGettingLocation];
    }
}

- (IBAction)navButtonClicked:(id)sender {
    TripViewController *tvc = [[TripViewController alloc] initWithNibName:@"TripViewController" bundle:nil];
    [self.navigationController pushViewController:tvc animated:YES];
}

#pragma mark
- (void)startGettingLocation {
    if (locationContoller == nil) {
        locationContoller = [[CLController alloc] init];
        locationContoller.delegate = self;
    }
    [locationContoller.locationManager startUpdatingLocation];

    //Disables device sleep mode
    [UIApplication sharedApplication].idleTimerDisabled = YES;
}

- (void)stopGettingLocation {
    [locationContoller.locationManager stopUpdatingLocation];

    //Re-enables device sleep mode
    [UIApplication sharedApplication].idleTimerDisabled = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

# pragma mark
- (void)locationUpdate:(CLLocation *)location {
    if ([location horizontalAccuracy] <= 5) {
        if (startPoint == nil && [location speed] > 0) {
            startPoint = location;
        }
        [_appDelegate saveLocation:location];
        CLLocationCoordinate2D coord = [location coordinate];
        lat.text = [self formatLat:coord.latitude];
        lon.text = [self formatLon:coord.longitude];
        alt.text = [NSString stringWithFormat:@"%.0f feet", [location altitude] * METERS_to_FEET];
        if ([location speed] != -1) {
            if ([location speed] > maxSpeedCache) {
                maxSpeedCache = [location speed];
                maxSpeed.text = [NSString stringWithFormat:@"Max: %.1f mph", [location speed] * MPS_to_MPH];
            }
            [self handleIdle:location];
            speed.text = [NSString stringWithFormat:@"%.1f mph", [location speed] * MPS_to_MPH];
        }
        double distance = [location distanceFromLocation:startPoint] * METERS_to_FEET;
        NSString *units = @"ft";
        if (distance > 5280) {
            distance /= 5280;
            units = @"miles";
        } 
        dist.text = [NSString stringWithFormat:@"%.1f %@", distance, units];
        if (prevPoint != nil) {
            totalDistance += [location distanceFromLocation:prevPoint];
            double tot = totalDistance * METERS_to_FEET;
            units = @"ft";
            if (tot > 5280) {
                tot /= 5280;
                units = @"miles";
            }
            totalDist.text = [NSString stringWithFormat:@"%.1f %@ travelled", tot, units];
        }
        
        elapsed.text = [self formatSecondsToTime:[[location timestamp] timeIntervalSinceDate:[startPoint timestamp]]];
        double progressPct = (double)([[location timestamp] timeIntervalSinceDate:lastIdleStart] + idleTime) / (double)[[location timestamp] timeIntervalSinceDate:[startPoint timestamp]];
        progressView.progress = progressPct;
        prevPoint = location;
    }
};

- (NSString *)formatLat:(double)latitude {
    NSString *NorS = @"N";
    if (latitude < 0) {
        NorS = @"S";
        latitude *= -1;
    }
    return [NSString stringWithFormat:@"%@ %@", [self formatLatOrLon:latitude], NorS];
}

- (NSString *)formatLon:(double)longitude {
    NSString *EorW = @"E";
    if (longitude < 0) {
        EorW = @"W";
        longitude *= -1;
    }
    return [NSString stringWithFormat:@"%@ %@", [self formatLatOrLon:longitude], EorW];
}

- (NSString *)formatLatOrLon:(double)coord {
    double minutes = fmod(coord, 1);
    double degrees = coord - minutes;
    minutes *= 60;
    double seconds = fmod(minutes, 1);
    minutes -= seconds;
    seconds *= 60;
    NSString *str = [NSString stringWithFormat:@"%.0f° %.0f\" %.3f'", degrees, minutes, seconds];
    return str;
}

- (void)handleIdle:(CLLocation *)location {
    if (!startPoint) {
        return;
    }
    if ([location speed] == 0) {
        if (!isIdle) {
            isIdle = YES;
            lastIdleStart = [location timestamp];
        }
        idle.text = [self formatSecondsToTime:[[location timestamp] timeIntervalSinceDate:lastIdleStart] + idleTime];
    } else if (isIdle) {
        isIdle = NO;
        idleTime += [[location timestamp] timeIntervalSinceDate:lastIdleStart];
        lastIdleStart = nil;
        idle.text = [self formatSecondsToTime:idleTime];
    }
}

- (NSString *)formatSecondsToTime:(double)seconds {
    NSNumber *theDouble = [NSNumber numberWithDouble:seconds];

    int inputSeconds = [theDouble intValue];
    int hours =  inputSeconds / 3600;
    int minutes = ( inputSeconds - hours * 3600 ) / 60;
    int secs = inputSeconds - hours * 3600 - minutes * 60;

    NSString *theTime = [NSString stringWithFormat:@"%.2d:%.2d:%.2d", hours, minutes, secs];
    return theTime;

}

- (void)locationError:(NSError *)error {
    lon.text = [error description];
}

# pragma mark
- (void)initText {
    
    [lat setText:@"Lat"];
    [lon setText:@"Lon"];
    [alt setText:@"Altitude"];
    if ([CLLocationManager locationServicesEnabled] && [CLLocationManager authorizationStatus] != kCLAuthorizationStatusDenied) {
        [lat setText:@"Latitude"];
        [lon setText:@"Longitude"];
    }
    [speed setText:@"N/A mph"];
    [maxSpeed setText:@"Max mph"];
    [idle setText:@"Idle for: 00:00"];
    [idle setText:@"Elapsed: 00:00"];
    self.progressView.progress = 0;
    [button setTitle:@"Start" forState:UIControlStateNormal];
}

@end
