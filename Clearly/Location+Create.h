//
//  Location+Create.h
//  Clearly
//
//  Created by Paul Benigeri on 3/16/13.
//  Copyright (c) 2013 Paul Benigeri. All rights reserved.
//

#import "Location.h"

@interface Location (Create)

+ (Location *)locationWithZipCode:(NSInteger *)zipcode
           inManagedObjectContext:(NSManagedObjectContext *) context;


@end
