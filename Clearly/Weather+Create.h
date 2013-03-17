//
//  Weather+Create.h
//  Clearly
//
//  Created by Paul Benigeri on 3/16/13.
//  Copyright (c) 2013 Paul Benigeri. All rights reserved.
//

#import "Weather.h"
#import "Location.h"

@interface Weather (Create)
+ (Weather *)weatherWithInfo:(NSDictionary *)weatherDictionary inManagedObjectContext:(NSManagedObjectContext *)context withLocation:(Location *) location;
@end
