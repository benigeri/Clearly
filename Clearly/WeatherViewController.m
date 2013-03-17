//
//  WeatherViewController.m
//  Clearly
//
//  Created by Paul Benigeri on 3/16/13.
//  Copyright (c) 2013 Paul Benigeri. All rights reserved.
//

#import "WeatherViewController.h"
#import <MapKit/MapKit.h>
#import "WeatherUndergroundAPI.h"

@interface WeatherViewController() 

@property (strong, nonatomic) CLPlacemark *placemark;
@property (weak, nonatomic) IBOutlet UILabel *zipcodeLabel;
@property (weak, nonatomic) IBOutlet UILabel *todayDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *todayWindLabel;

@property (weak, nonatomic) IBOutlet UILabel *todayTempLabel;
@property (weak, nonatomic) IBOutlet UILabel *todayPrecipitationLabel;
@property (weak, nonatomic) IBOutlet UILabel *yesterdayDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *yesterdayWindLabel;
@property (weak, nonatomic) IBOutlet UILabel *yesterdayTempLabel;
@property (weak, nonatomic) IBOutlet UILabel *yesterdayPrecipitationLabel;
@property (weak, nonatomic) IBOutlet UILabel *tempDifferenceLabel;
@property (weak, nonatomic) IBOutlet UILabel *windDifferenceLabel;
@property (weak, nonatomic) NSString prevDate;
@property (strong, nonatomic) NSDictionary *todayWeather;
@property (strong, nonatomic) NSDictionary *yesterdayWeather;

@end

@implementation WeatherViewController 

- (void)showWeather:(CLPlacemark*) placemark
{

    self.placemark = placemark;
    
}

- (void) viewDidLoad {
    self.zipcodeLabel.text = self.placemark.postalCode;
    NSCalendar *cal = [NSCalendar currentCalendar];

    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyyMMdd"];
    
    NSString *todayString = [dateFormat stringFromDate:[NSDate date]];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setDay:-1];
    NSDate *yesterday = [cal dateByAddingComponents:components toDate:[NSDate date] options:0];

    NSString *yesterdayString = [dateFormat stringFromDate:yesterday];
    NSLog(@"yesterday string; %@", yesterdayString);
    NSDictionary *todayDictionary = [WeatherUndergroundAPI getPastDate:todayString withZipCode:self.placemark.postalCode];
    NSDictionary *yesterdayDictionary = [WeatherUndergroundAPI getPastDate:yesterdayString withZipCode:self.placemark.postalCode];

    NSLog(@"yesterday!!!!:%@", yesterdayDictionary);;
    
    self.todayDateLabel.text = [todayDictionary valueForKey:@"day"];
    self.todayWindLabel.text = [todayDictionary valueForKey:@"windm"];
//    self.todayPrecipitationLabel.text = [todayDictionary valueForKey:@"percipim"];
    self.todayTempLabel.text = [todayDictionary valueForKey:@"tempm"];
    self.yesterdayDateLabel.text = [yesterdayDictionary valueForKey:@"day"];
    self.yesterdayWindLabel.text = [yesterdayDictionary valueForKey:@"windm"];
//    self.yesterdayPrecipitationLabel.text = [yesterdayDictionary valueForKey:@"percipim"];
    self.yesterdayTempLabel.text = [yesterdayDictionary valueForKey:@"tempm"];

}



@end
