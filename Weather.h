//
//  Weather.h
//  Clearly
//
//  Created by Paul Benigeri on 3/16/13.
//  Copyright (c) 2013 Paul Benigeri. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Weather : NSManagedObject

@property (nonatomic, retain) NSString * date;
@property (nonatomic, retain) NSDate * icon;
@property (nonatomic, retain) NSNumber * tempI;
@property (nonatomic, retain) NSNumber * windM;
@property (nonatomic, retain) NSNumber * tempF;
@property (nonatomic, retain) NSNumber * windI;
@property (nonatomic, retain) NSDecimalNumber * precipitation;
@property (nonatomic, retain) NSManagedObject *forLocation;

@end
