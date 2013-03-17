//
//  Weather+Create.m
//  Clearly
//
//  Created by Paul Benigeri on 3/16/13.
//  Copyright (c) 2013 Paul Benigeri. All rights reserved.
//

#import "Weather+Create.h"

@implementation Weather (Create)
+ (Weather *)weatherWithInfo:(NSDictionary *)weatherDictionary inManagedObjectContext:(NSManagedObjectContext *)context withLocation:(Location *) location {
    Weather *weather = nil;
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyymmdd"];
    NSString *dateString = [dateFormat stringFromDate:[weatherDictionary valueForKey:@"day"]];
    NSString *zipString = [NSString stringWithFormat:@"%d", location.zipcode];
    NSString *unique = [NSString stringWithFormat:@"%@%@", dateString, zipString];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Weather"];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"unique"
                                                              ascending:YES
                                                               selector:@selector(localizedCaseInsensitiveCompare:)]];
    request.predicate = [NSPredicate predicateWithFormat:@"unique = %@", unique];
    
    NSError *error;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    if (!matches || ([matches count] > 1)) {
        //            NSLog(@"3. ERROR");
    } else if (![matches count]) {
        weather = [NSEntityDescription insertNewObjectForEntityForName:@"Weather" inManagedObjectContext:context];
        weather.day = [weatherDictionary valueForKey:@"day"];
        weather.tempm = [[weatherDictionary valueForKey:@"tempm"] integerValue];
        weather.tempi = [[weatherDictionary valueForKey:@"tempi"] integerValue];
        weather.precipm = [[weatherDictionary valueForKey:@"precipm"] integerValue];;
        weather.windm = [[weatherDictionary valueForKey:@"windm"] integerValue];;
        weather.precipi = [[weatherDictionary valueForKey:@"precipi"] integerValue];;
        weather.windi = [[weatherDictionary valueForKey:@"windi"] integerValue];;
        weather.unique = unique;
        weather.forLocation = location;
    } else {
        weather = [matches lastObject];
        //            NSLog(@"2. %@", name);
    }
    
    return weather;
    
}

@end
