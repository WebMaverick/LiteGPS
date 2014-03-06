//
//  AppDelegate.h
//  LiteGPS
//
//  Created by Adam Hardtke on 10/19/12.
//  Copyright (c) 2012 Adam Hardtke. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TripViewController.h"

@class ViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) ViewController *viewController;
@property (strong, nonatomic) IBOutlet TripViewController *tripViewController;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (strong, nonatomic) NSNumber *tripId;


- (void)incrementTripId;
- (void)saveLocation:(CLLocation *)theLocation;
- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
