//
//  ViewController.h
//  LiteGPS
//
//  Created by Adam Hardtke on 10/19/12.
//  Copyright (c) 2012 Adam Hardtke. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CLController.h"
#import "AppDelegate.h"


@interface ViewController : UIViewController {
    CLController *locationContoller;
    IBOutlet UILabel *lat;
    IBOutlet UILabel *lon;
    IBOutlet UILabel *alt;
    IBOutlet UILabel *speed;
    IBOutlet UILabel *maxSpeed;
    IBOutlet UILabel *dist;
    IBOutlet UILabel *totalDist;
    IBOutlet UILabel *idle;
    IBOutlet UILabel *elapsed;
    IBOutlet UIProgressView *progressView;
    IBOutlet UIButton *button;
}

@property (nonatomic, strong) AppDelegate *appDelegate;
@property (nonatomic, strong) IBOutlet UILabel *lat;
@property (nonatomic, strong) IBOutlet UILabel *lon;
@property (nonatomic, strong) IBOutlet UILabel *speed;
@property (nonatomic, strong) IBOutlet UILabel *alt;
@property (nonatomic, strong) IBOutlet UILabel *maxSpeed;
@property (nonatomic, strong) IBOutlet UILabel *dist;
@property (nonatomic, strong) IBOutlet UILabel *totalDist;
@property (nonatomic, strong) IBOutlet UILabel *idle;
@property (nonatomic, strong) IBOutlet UILabel *elapsed;
@property (nonatomic, strong) IBOutlet UIProgressView *progressView;
@property (nonatomic, strong) IBOutlet UIButton *button;

- (IBAction)buttonClicked:(id)sender;
- (void)stopGettingLocation;
- (void)locationUpdate:(CLLocation *)location;
- (void)locationError:(NSError *)error;
- (void)initText;

@end
