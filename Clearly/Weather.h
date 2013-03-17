//
//  Weather.h
//  Clearly
//
//  Created by Paul Benigeri on 3/16/13.
//  Copyright (c) 2013 Paul Benigeri. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Location;

@interface Weather : NSManagedObject

@property (nonatomic) NSTimeInterval day;
@property (nonatomic) int16_t tempm;
@property (nonatomic) int16_t tempi;
@property (nonatomic) int16_t precipm;
@property (nonatomic) int16_t windm;
@property (nonatomic) int16_t precipi;
@property (nonatomic) int16_t windi;
@property (nonatomic, retain) NSString * iconname;
@property (nonatomic, retain) NSData * icondata;
@property (nonatomic, retain) NSString * unique;
@property (nonatomic, retain) Location *forLocation;

@end
