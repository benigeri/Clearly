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

    [self fetchTodayWeather];
    
    [self fetchPrevWeather: [self prevDateByNumDays:-6]];

    [self updateUI];

}

- (void) updateUI {
    self.todayDateLabel.text = [self.todayWeather valueForKey:@"day"];
    self.todayWindLabel.text = [self.todayWeather valueForKey:@"windi"];
    //    self.todayPrecipitationLabel.text = [todayDictionary valueForKey:@"percipim"];
    self.todayTempLabel.text = [self.todayWeather valueForKey:@"tempi"];
    self.yesterdayDateLabel.text = [self.prevWeather valueForKey:@"day"];
    self.yesterdayWindLabel.text = [self.prevWeather  valueForKey:@"windi"];
    //    self.yesterdayPrecipitationLabel.text = [yesterdayDictionary valueForKey:@"percipim"];
    self.yesterdayTempLabel.text = [self.prevWeather  valueForKey:@"tempi"];
    
    [self updateClearlyWeather];
}

- (NSDate *) prevDateByNumDays:(int) n {
    NSCalendar *cal = [NSCalendar currentCalendar];
    
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setDay:n];
    
    return [cal dateByAddingComponents:components toDate:[NSDate date] options:0];
}

- (void) updateClearlyWeather {

    NSInteger todayTemp = [[self.todayWeather valueForKey:@"tempi"] integerValue];
    NSInteger prevTemp = [[self.prevWeather valueForKey:@"tempi"] integerValue];
    NSLog(@"temps: %d, %d %d", todayTemp, prevTemp, prevTemp - todayTemp);
    NSString *tempDesc;
    if (todayTemp > prevTemp) {
        tempDesc = [NSString stringWithFormat:@"%d°F warmer than", todayTemp - prevTemp];
    } else if (todayTemp < prevTemp){
        tempDesc = [NSString stringWithFormat:@"%d°F colder than",  prevTemp - todayTemp];
    } else {
        tempDesc = [NSString stringWithFormat:@"the same temperature as"];
    }
    
    
    
    NSString *yesterdayString = [self dateToString: [self prevDateByNumDays:-5]];
    NSString *dateDesc;
    if ([[self dateToString:self.prevDate] isEqualToString:yesterdayString] ) {
        dateDesc = @"yesterday";
    } else {
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"EEEE MMMM d, YYYY"];
        dateDesc = [dateFormat stringFromDate:self.prevDate];
    }
    
    NSString *clearlyTemp = [NSString stringWithFormat:@"It's %@ %@.", tempDesc, dateDesc];
    self.tempDifferenceLabel.text = clearlyTemp;

}

- (NSString *) dateToString:(NSDate *) date {
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyyMMdd"];
    return [dateFormat stringFromDate:date];

}
- (void) fetchTodayWeather {
    NSDate *today = [self prevDateByNumDays:-2];
    

    
    NSString *todayString = [self dateToString:today];
    NSLog(@"today string: %@", todayString);
    self.todayWeather = [WeatherUndergroundAPI getPastDate:todayString withZipCode:self.placemark.postalCode];
}

- (void) fetchPrevWeather:(NSDate *)prevDate {
    
    self.prevDate = prevDate;
    
    NSString *prevString = [self dateToString:self.prevDate];
    self.prevWeather = [WeatherUndergroundAPI getPastDate:prevString withZipCode:self.placemark.postalCode];
}



@end
