//
//  RecordViewController.h
//  Lokator
//
//  Created by Paweł Ksieniewicz on 27.05.2013.
//  Copyright (c) 2013 Paweł Ksieniewicz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "RoundedViewController.h"

@interface RecordViewController : RoundedViewController {
    IBOutlet UIView *recordDot, *upperView, *splash;
    IBOutlet UITapGestureRecognizer *doubleTap, *trippleTap;
    IBOutlet UISwipeGestureRecognizer *swipeUp;
    IBOutlet MKMapView *map;
    BOOL recording;
}

- (IBAction)doubleTap:(UITapGestureRecognizer *)sender;
- (IBAction)trippleTap:(UITapGestureRecognizer *)sender;

@end