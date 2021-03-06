//
//  GetLocationViewController.m
//  Clearly
//
//  Created by Paul Benigeri on 3/16/13.
//  Copyright (c) 2013 Paul Benigeri. All rights reserved.
//

#import "GetLocationViewController.h"
#import <MapKit/MapKit.h>

@interface GetLocationViewController ()
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLGeocoder *geocoder;
@property (strong, nonatomic) CLPlacemark *placemark;
@property (weak, nonatomic) IBOutlet UILabel *latitudeLabel;
@property (weak, nonatomic) IBOutlet UILabel *longitudeLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (strong, nonatomic) IBOutlet UIImageView *logo;


- (IBAction)getCurrentLocation:(id)sender;
- (IBAction)getWeather:(id)sender;
@end


@implementation GetLocationViewController


- (IBAction)getCurrentLocation:(id)sender {
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
//    mapView.showsUserLocation = YES ;

    
    // dispatch getting location to other thread
    dispatch_queue_t loaderQ = dispatch_queue_create("location loader", NULL);
    dispatch_async(loaderQ, ^{
        [self.locationManager startUpdatingLocation];
    });
}

- (IBAction)getWeather:(id)sender {
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES];

    // Do any additional setup after loading the view, typically from a nib.
    [self.logo setImage:[UIImage imageNamed:@"logo.png"]];
    self.locationManager = [[CLLocationManager alloc] init];
    self.geocoder = [[CLGeocoder alloc] init];
    

}


- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"didUpdateToLocation: %@", newLocation);
    CLLocation *currentLocation = newLocation;
    
    if (currentLocation != nil) {
        self.longitudeLabel.text = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.longitude];
        self.latitudeLabel.text = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.latitude];
    }
}

-(void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    CLLocation *currentLocation = [locations lastObject];
    
    if (currentLocation != nil) {
        self.longitudeLabel.text = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.longitude];
        self.latitudeLabel.text = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.latitude];
    }
    [self.locationManager stopUpdatingLocation];

    // Reverse Geocoding
    NSLog(@"Resolving the Address");
    [self.geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        NSLog(@"Found placemarks: %@, error: %@", placemarks, error);
        if (error == nil && [placemarks count] > 0) {
            self.placemark = [placemarks lastObject];
            self.addressLabel.text = [NSString stringWithFormat:@"%@ %@\n%@ %@\n%@\n%@",
                                 self.placemark.subThoroughfare, self.placemark.thoroughfare,
                                 self.placemark.postalCode, self.placemark.locality,
                                 self.placemark.administrativeArea,
                                 self.placemark.country];
        } else {
            NSLog(@"%@", error.debugDescription);
        }
    } ];
    CLLocationDistance visibleDistance = 10000; // 100 kilometers

    mapView.showsUserLocation=YES;

    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(currentLocation.coordinate, visibleDistance, visibleDistance);
    [mapView setRegion:region animated:YES];
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([sender isKindOfClass:[UIButton class]]) {
        if ([segue.identifier isEqualToString:@"weathersegue"]) {
            NSLog(@"SEGUEDD!");
            [self.navigationController setNavigationBarHidden:YES];
            if ([segue.destinationViewController respondsToSelector:@selector(showWeather:)]) {
                [segue.destinationViewController performSelector:@selector(showWeather:) withObject:self.placemark];
//            if ([segue.destinationViewController respondsToSelector:@selector(setImageURL:)]) {
//                NSURL *url = [FlickrFetcher urlForPhoto:self.photos[indexPath.row] format:FlickrPhotoFormatLarge];
//
//                [segue.destinationViewController setTitle:[self titleForRow:indexPath.row]];
//                NSDictionary *photo = [self photos][indexPath.row];
//                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//                NSMutableArray *recentPhotos = [[NSMutableArray alloc] initWithArray:[defaults arrayForKey:@"recentPhotos"]];
//                if ([recentPhotos containsObject:photo]){
//                    [recentPhotos removeObject:photo];
//                }
//                
//                [recentPhotos insertObject:photo atIndex:0];
//                [defaults setObject:recentPhotos forKey:@"recentPhotos"];
//                [defaults synchronize];
//            }
        
            }
        }
    }
}

@synthesize mapView ;



@end
