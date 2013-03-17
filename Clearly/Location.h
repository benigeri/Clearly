//
//  Location.h
//  Clearly
//
//  Created by Paul Benigeri on 3/16/13.
//  Copyright (c) 2013 Paul Benigeri. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Weather;

@interface Location : NSManagedObject

@property (nonatomic, retain) NSNumber * zipCode;
@property (nonatomic, retain) NSSet *pastWeather;
@end

@interface Location (CoreDataGeneratedAccessors)

- (void)addPastWeatherObject:(Weather *)value;
- (void)removePastWeatherObject:(Weather *)value;
- (void)addPastWeather:(NSSet *)values;
- (void)removePastWeather:(NSSet *)values;

@end
