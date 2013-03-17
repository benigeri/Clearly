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
@property (weak, nonatomic) IBOutlet UIButton *prevDateButton;
@property (weak, nonatomic) IBOutlet UIButton *nextDateButton;
@property (nonatomic) int prevCount;
@property (weak, nonatomic) UIColor *background;

@end

@implementation WeatherViewController

- (void)showWeather:(CLPlacemark*) placemark
{

    self.placemark = placemark;
    
}

- (void) viewDidLoad {
    // Add swipeGestures
    UISwipeGestureRecognizer *oneFingerSwipeLeft = [[UISwipeGestureRecognizer alloc]
                                                     initWithTarget:self
                                                     action:@selector(oneFingerSwipeLeft:)];
    [oneFingerSwipeLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
    [[self view] addGestureRecognizer:oneFingerSwipeLeft];
    
    UISwipeGestureRecognizer *oneFingerSwipeRight = [[UISwipeGestureRecognizer alloc]
                                                      initWithTarget:self
                                                      action:@selector(oneFingerSwipeRight:)] ;
    [oneFingerSwipeRight setDirection:UISwipeGestureRecognizerDirectionRight];
    [[self view] addGestureRecognizer:oneFingerSwipeRight];
    
    
    self.zipcodeLabel.text = self.placemark.postalCode;
    self.prevCount = 3;
    [self fetchTodayWeather];
    
    [self fetchPrevWeather: [self prevDateByNumDays:-5]];

    [self updateUI];

}

- (void)oneFingerSwipeLeft:(UITapGestureRecognizer *)recognizer {
    [self changeDateBackward];
}

- (void)oneFingerSwipeRight:(UITapGestureRecognizer *)recognizer {
    [self changeDateForward];
}

- (void) changeDateForward {
    self.prevDate = [self prevDateByNumDays:- --self.prevCount];
    [self fetchPrevWeather: self.prevDate];
    
    [self updateUI];
}

- (void) changeDateBackward {
    self.prevDate = [self prevDateByNumDays:- ++self.prevCount];
    [self fetchPrevWeather: self.prevDate];
    [self updateUI];
    
}

- (IBAction)switchNextDate:(id)sender {
 
    [self changeDateForward];
}

- (IBAction)switchPrevDate:(id)sender {
    
    [self changeDateBackward];

}


- (void) updateUI {
   
    dispatch_async(dispatch_get_main_queue(), ^{
        self.view.backgroundColor = self.background;
    });
    
    [self updateClearlyWeather];
    
    self.todayDateLabel.text = [self.todayWeather valueForKey:@"day"];
    self.todayWindLabel.text = [self.todayWeather valueForKey:@"windi"];
    self.todayTempLabel.text = [self.todayWeather valueForKey:@"tempi"];
    self.yesterdayDateLabel.text = [self.prevWeather valueForKey:@"day"];
    self.yesterdayWindLabel.text = [self.prevWeather  valueForKey:@"windi"];
    self.yesterdayTempLabel.text = [self.prevWeather  valueForKey:@"tempi"];
    
    if (self.prevCount == 0) {
        [self.nextDateButton setEnabled:NO];
    } else {
        [self.nextDateButton setEnabled:YES];
    }
    

}

- (NSDate *) prevDateByNumDays:(int) n {
    NSCalendar *cal = [NSCalendar currentCalendar];
    
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setDay:n];
    
    return [cal dateByAddingComponents:components toDate:[NSDate date] options:0];
}

- (void) updateClearlyWeather {

    self.tempDifferenceLabel.text = [self generateTempDescription];
    self.windDifferenceLabel.text = [self generateWindDescription];

}

- (NSString *) generateWindDescription {
    NSInteger todayWind = [[self.todayWeather valueForKey:@"windi"] integerValue];
    NSInteger prevWind = [[self.prevWeather valueForKey:@"windi"] integerValue];
    NSString *windDesc;

    if (todayWind > prevWind) {
        windDesc = [NSString stringWithFormat:@"%dmph stronger than", todayWind - prevWind];
    } else if (todayWind < prevWind){
        windDesc = [NSString stringWithFormat:@"%dmph weaker than",  prevWind - todayWind];
    } else {
        windDesc = [NSString stringWithFormat:@"the same as"];
    }
    
    return [NSString stringWithFormat:@"Today's wind is %@ %@.", windDesc, [self generateDateDesc]];

}

- (NSString *) generateDateDesc {
    NSString *yesterdayString = [self dateToString: [self prevDateByNumDays:-5]];
    NSString *dateDesc;
    if ([[self dateToString:self.prevDate] isEqualToString:yesterdayString] ) {
        dateDesc = @"yesterday";
    } else {
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"EEEE MMMM d, YYYY"];
        dateDesc = [dateFormat stringFromDate:self.prevDate];
    }
    return dateDesc;
    
}
- (NSString *) generateTempDescription {
    NSInteger todayTemp = [[self.todayWeather valueForKey:@"tempi"] integerValue];
    NSInteger prevTemp = [[self.prevWeather valueForKey:@"tempi"] integerValue];
    NSLog(@"temps: %d, %d %d", todayTemp, prevTemp, prevTemp - todayTemp);
    NSString *tempDesc;
    if (todayTemp > prevTemp) {
        tempDesc = [NSString stringWithFormat:@"%d°F warmer than", todayTemp - prevTemp];
        self.background = [UIColor redColor];
    } else if (todayTemp < prevTemp){
        tempDesc = [NSString stringWithFormat:@"%d°F colder than",  prevTemp - todayTemp];
        self.background = [UIColor blueColor];
    } else {
        tempDesc = [NSString stringWithFormat:@"the same temperature as"];
        self.background = [UIColor greenColor];
    }
    
    return [NSString stringWithFormat:@"It's %@ %@.", tempDesc, [self generateDateDesc]];
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
