//
//  TripViewController.h
//  LiteGPS
//
//  Created by Adam Hardtke on 5/15/13.
//  Copyright (c) 2013 Adam Hardtke. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TripViewController : UITableViewController

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSArray *trips;

@end
