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

@property (nonatomic) int32_t zipcode;
@property (nonatomic, retain) NSSet *hasWeather;
@end

@interface Location (CoreDataGeneratedAccessors)

- (void)addHasWeatherObject:(Weather *)value;
- (void)removeHasWeatherObject:(Weather *)value;
- (void)addHasWeather:(NSSet *)values;
- (void)removeHasWeather:(NSSet *)values;

@end
