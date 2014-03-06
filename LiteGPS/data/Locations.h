//
//  Locations.h
//  LiteGPS
//
//  Created by Adam Hardtke on 5/15/13.
//  Copyright (c) 2013 Adam Hardtke. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Locations : NSManagedObject

@property (nonatomic, retain) NSNumber * alt;
@property (nonatomic, retain) NSNumber * accuracy;
@property (nonatomic, retain) NSNumber * course;
@property (nonatomic, retain) NSNumber * lat;
@property (nonatomic, retain) NSNumber * lon;
@property (nonatomic, retain) NSNumber * speed;
@property (nonatomic, retain) NSDate * time;
@property (nonatomic, retain) NSNumber * tripId;

@end
