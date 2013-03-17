//
//  GetLocationViewController.h
//  Clearly
//
//  Created by Paul Benigeri on 3/16/13.
//  Copyright (c) 2013 Paul Benigeri. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface GetLocationViewController : UIViewController <CLLocationManagerDelegate> {
    MKMapView *mapView;

}
@property (nonatomic, retain) IBOutlet MKMapView *mapView ;

@end
