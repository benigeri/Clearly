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
@property (weak, nonatomic) NSDate *prevDate;
@property (strong, nonatomic) NSDictionary *todayWeather;
@property (strong, nonatomic) NSDictionary *prevWeather;

@end

@implementation WeatherViewController 

- (void)showWeather:(CLPlacemark*) placemark
{

    self.placemark = placemark;
    
}

- (void) viewDidLoad {
    self.zipcodeLabel.text = self.placemark.postalCode;

    NSCalendar *cal = [NSCalendar currentCalendar];
    
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setDay:-1];
    
    NSDate *yesterday = [cal dateByAddingComponents:components toDate:[NSDate date] options:0];

    [self fetchTodayWeather];
    
    [self fetchPrevWeather:yesterday];

    [self updateUI];

}

- (void) updateUI {
    self.todayDateLabel.text = [self.todayWeather valueForKey:@"day"];
    self.todayWindLabel.text = [self.todayWeather valueForKey:@"windm"];
    //    self.todayPrecipitationLabel.text = [todayDictionary valueForKey:@"percipim"];
    self.todayTempLabel.text = [self.todayWeather valueForKey:@"tempm"];
    self.yesterdayDateLabel.text = [self.prevWeather valueForKey:@"day"];
    self.yesterdayWindLabel.text = [self.prevWeather  valueForKey:@"windm"];
    //    self.yesterdayPrecipitationLabel.text = [yesterdayDictionary valueForKey:@"percipim"];
    self.yesterdayTempLabel.text = [self.prevWeather  valueForKey:@"tempm"];
}

- (void) fetchTodayWeather {
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyyMMdd"];
    
    NSString *todayString = [dateFormat stringFromDate:[NSDate date]];
    self.todayWeather = [WeatherUndergroundAPI getPastDate:todayString withZipCode:self.placemark.postalCode];
}

- (void) fetchPrevWeather:(NSDate *)prevDate {
    
    self.prevDate = prevDate;
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyyMMdd"];

    
    NSString *prevString = [dateFormat stringFromDate:self.prevDate];
    self.prevWeather = [WeatherUndergroundAPI getPastDate:prevString withZipCode:self.placemark.postalCode];
}



@end
