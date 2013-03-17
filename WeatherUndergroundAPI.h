//
//  WeatherUndergroundAPI.h
//  Clearly
//
//  Created by Paul Benigeri on 3/16/13.
//  Copyright (c) 2013 Paul Benigeri. All rights reserved.
//

#import <Foundation/Foundation.h>


#define WUKEYID @"db4e0f68f60312d4"
#define WUAPIPREFIX @"http://api.wunderground.com/api/"

@interface WeatherUndergroundAPI : NSObject
+ (NSDictionary *)executeWeatherUndergroundFetch:(NSString *)query withZipCode:(NSString *) zipCode;
+ (NSDictionary *)getPastDate:(NSString *)date withZipCode:(NSString *) zipCode;
+ (NSDictionary *)getTomorrow:(NSString *) zipCode;

@end
