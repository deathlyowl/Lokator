//
//  RecordViewController.h
//  Lokator
//
//  Created by Paweł Ksieniewicz on 27.05.2013.
//  Copyright (c) 2013 Paweł Ksieniewicz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "RoundedViewController.h"

@interface RecordViewController : RoundedViewController <CLLocationManagerDelegate> {
    CLLocationManager *locationManager;
    
    CLLocation *currentLocation;
    
    IBOutlet UIView *recordDot, *upperView, *splash, *pointer;
    IBOutlet UITapGestureRecognizer *doubleTap, *trippleTap;
    IBOutlet UISwipeGestureRecognizer *swipeUp;
    IBOutlet MKMapView *map;
    
    NSMutableArray *record;
    
    int scale;
    BOOL recording;
}

- (IBAction)doubleTap:(UITapGestureRecognizer *)sender;
- (IBAction)trippleTap:(UITapGestureRecognizer *)sender;
- (IBAction)zoomIn:(id)sender;
- (IBAction)zoomOut:(id)sender;

@end