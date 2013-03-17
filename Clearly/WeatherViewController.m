//
//  WeatherViewController.m
//  Clearly
//
//  Created by Paul Benigeri on 3/16/13.
//  Copyright (c) 2013 Paul Benigeri. All rights reserved.
//

#import "WeatherViewController.h"
#import <MapKit/MapKit.h>

@interface WeatherViewController() 

@property (strong, nonatomic) CLPlacemark *placemark;
@property (weak, nonatomic) IBOutlet UILabel *zipcodeLabel;

@end

@implementation WeatherViewController 

- (void)showWeather:(CLPlacemark*) placemark
{

    self.placemark = placemark;
    
}

- (void) viewDidLoad {
    self.zipcodeLabel.text = self.placemark.postalCode;

}
@end
