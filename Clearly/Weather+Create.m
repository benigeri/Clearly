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
    NSString *unique = @"asdfasdF";
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
    } else {
        weather = [matches lastObject];
        //            NSLog(@"2. %@", name);
    }
    
    return weather;
    
}

@end
