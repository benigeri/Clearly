//
//  Location+Create.m
//  Clearly
//
//  Created by Paul Benigeri on 3/16/13.
//  Copyright (c) 2013 Paul Benigeri. All rights reserved.
//

#import "Location+Create.h"

@implementation Location (Create)
+ (Location *)locationWithZipCode:(NSInteger *)zipcode
           inManagedObjectContext:(NSManagedObjectContext *) context {
    

    Location *location = nil;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Location"];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"zipcode" ascending:YES]];
    request.predicate = [NSPredicate predicateWithFormat:@"zipcode = %@", *(zipcode)];
    
    // Execute the fetch
    
    NSError *error = nil;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    // Check what happened in the fetch
    
    if (!matches || ([matches count] > 1)) {
        
    } else if (![matches count]) {         location = [NSEntityDescription insertNewObjectForEntityForName:@"Location" inManagedObjectContext:context];
        location.zipcode = *(zipcode);

    } else { 
        location = [matches lastObject];
    }

    return location;
}
@end
