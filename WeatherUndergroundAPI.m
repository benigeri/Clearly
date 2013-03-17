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
    NSLog(@"query: %@", query);
    query = [query stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    NSLog(@"[%@ %@] sent %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), query);
    NSData *jsonData = [[NSString stringWithContentsOfURL:[NSURL URLWithString:query] encoding:NSUTF8StringEncoding error:nil] dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    NSDictionary *results = jsonData ? [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves error:&error] : nil;
    if (error) NSLog(@"[%@ %@] JSON error: %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), error.localizedDescription);
//    NSLog(@"[%@ %@] received %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), results);
//    NSLog(@"Results: %@", results);
    return results;
    
}

+ (NSDictionary *)getPastDate:(NSString *)date withZipCode:(NSString *) zipCode {
    NSString *query = [NSString stringWithFormat:@"history_%@", date];
    NSDictionary *results = [WeatherUndergroundAPI executeWeatherUndergroundFetch:query withZipCode:zipCode];
    NSDictionary *weatherForDate = [results valueForKeyPath:@"history.dailysummary"];
//    NSLog(@"%@", weatherForDate);
    NSMutableDictionary *weatherDictionary = [[NSMutableDictionary alloc] init];
    [weatherDictionary setObject:date forKey:@"day"];
    [weatherDictionary setObject:[[weatherForDate valueForKey:@"precipm"] objectAtIndex:0] forKey:@"precipm"];
    [weatherDictionary setObject:[[weatherForDate valueForKey:@"precipi"] objectAtIndex:0] forKey:@"precipi"];
    [weatherDictionary setObject:[[weatherForDate valueForKey:@"maxtempi"] objectAtIndex:0] forKey:@"tempi"];
    [weatherDictionary setObject:[[weatherForDate valueForKey:@"maxtempm"] objectAtIndex:0] forKey:@"tempm"];
    [weatherDictionary setObject:[[weatherForDate valueForKey:@"maxwspdi"] objectAtIndex:0] forKey:@"windi"];
    [weatherDictionary setObject:[[weatherForDate valueForKey:@"maxwspdm"] objectAtIndex:0] forKey:@"windm"];

    return weatherDictionary;
}

+ (NSDictionary *)getTomorrow:(NSString *) zipCode {
    NSString *query = [NSString stringWithFormat:@"forecast"];
    NSDictionary *results = [WeatherUndergroundAPI executeWeatherUndergroundFetch:query withZipCode:zipCode];
    NSDictionary *weatherForDate = [[results valueForKeyPath:@"forecast.simpleforecast.forecastday"] objectAtIndex:1];
//    NSLog(@"%@", weatherForDate);
    NSMutableDictionary *weatherDictionary = [[NSMutableDictionary alloc] init];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setDay:[[weatherDictionary valueForKeyPath:@"date.day"] intValue]];
    [comps setMonth:[[weatherDictionary valueForKeyPath:@"date.month"] intValue]];
    [comps setYear:[[weatherDictionary valueForKeyPath:@"date.year"] intValue]];
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDate *day = [cal dateFromComponents:comps];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyymmdd"];
    NSString *dateString = [dateFormat stringFromDate:day];
    [weatherDictionary setObject:dateString forKey:@"day"];
    [weatherDictionary setObject:[[weatherForDate valueForKey:@"qpf_allday.mm"] object] forKey:@"precipm"];
    [weatherDictionary setObject:[weatherForDate valueForKeyPath:@"qpf_allday.in"] forKey:@"precipi"];
    [weatherDictionary setObject:[weatherForDate valueForKeyPath:@"fahrenheit"] forKey:@"tempi"];
    [weatherDictionary setObject:[weatherForDate valueForKeyPath:@"high.celcius"] forKey:@"tempm"];
    [weatherDictionary setObject:[weatherForDate valueForKeyPath:@"maxwind.mph"] forKey:@"windi"];
    [weatherDictionary setObject:[weatherForDate valueForKeyPath:@"maxwind.kph"] forKey:@"windm"];

    return weatherDictionary;


}
@end
