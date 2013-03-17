//
//  WeatherUndergroundAPI.m
//  Clearly
//
//  Created by Paul Benigeri on 3/16/13.
//  Copyright (c) 2013 Paul Benigeri. All rights reserved.
//

#import "WeatherUndergroundAPI.h"
@implementation WeatherUndergroundAPI
// http://api.wunderground.com/api/db4e0f68f60312d4/history_20130316/q/94305.json
//http://api.wunderground.com/api/db4e0f68f60312d4/forecast/q/94305.json

// prefix query location .json
+ (NSDictionary *)executeWeatherUndergroundFetch:(NSString *)query withZipCode:(NSString *) zipCode
{
    query = [NSString stringWithFormat:@"%@%@/%@/q/%@.json", WUAPIPREFIX, WUKEYID, query, zipCode];
    query = [query stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"[%@ %@] sent %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), query);
    NSData *jsonData = [[NSString stringWithContentsOfURL:[NSURL URLWithString:query] encoding:NSUTF8StringEncoding error:nil] dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    NSDictionary *results = jsonData ? [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves error:&error] : nil;
    if (error) NSLog(@"[%@ %@] JSON error: %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), error.localizedDescription);
    NSLog(@"[%@ %@] received %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), results);
//    NSLog(@"Results: %@", results);
    return results;
    
}

+ (NSDictionary *)getPastDate:(NSString *)date withZipCode:(NSString *) zipCode {
    NSString *query = [NSString stringWithFormat:@"history_%@", date];
    NSDictionary *results = [WeatherUndergroundAPI executeWeatherUndergroundFetch:query withZipCode:zipCode];
    NSDictionary *weatherForDate = [results valueForKeyPath:@"history.dailysummary"];
    NSLog(@"%@", weatherForDate);
    return weatherForDate;
}

+ (NSDictionary *)getTomorrow:(NSString *) zipCode {
    NSString *query = [NSString stringWithFormat:@"forecast"];
    NSDictionary *results = [WeatherUndergroundAPI executeWeatherUndergroundFetch:query withZipCode:zipCode];
    NSDictionary *weatherForDate = [[results valueForKeyPath:@"forecast.simpleforecast.forecastday"] objectAtIndex:1];
    NSLog(@"%@", weatherForDate);
    return weatherForDate;


}
@end
