//
//  RecordViewController.m
//  Lokator
//
//  Created by Paweł Ksieniewicz on 27.05.2013.
//  Copyright (c) 2013 Paweł Ksieniewicz. All rights reserved.
//

#import "RecordViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "UIColor+Hex.h"
#import "Animator.h"

@implementation RecordViewController

- (void)viewDidLoad{
    
    [super viewDidLoad];
    
    recording = NO;
    
    [self.view setBorderWidth:5
                     andColor:[UIColor clearColor]];
    
    [recordDot setCornerRadius:8];
    [recordDot setBackgroundColor:[UIColor colorWithCSS:@"#EE0000"]];
    
    [splash setMaskFromImage:[UIImage imageNamed:@"marker.png"]];
    [pointer setMaskFromImage:[UIImage imageNamed:@"markerAlt.png"]];
    [splash setCornerRadius:24];
    
    [doubleTap requireGestureRecognizerToFail:trippleTap];
    
    // Initialize location manager
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    [locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    //NSLog(@"Location: %@", newLocation);
    
    if ([newLocation distanceFromLocation:oldLocation]) {
        currentLocation = newLocation;
        
        MKMapPoint mapPoint = MKMapPointForCoordinate(newLocation.coordinate);
        float zoom = 10000;
        
        
        [map setVisibleMapRect:MKMapRectMake(mapPoint.x-zoom/2, mapPoint.y-zoom/2, zoom, zoom)
                      animated:YES];
    }
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    // Animate icon
    if (!animated){
        [splash.layer addAnimation:[Animator disappear] forKey:@"disappearAnimation"];
        [pointer.layer addAnimation:[Animator appear] forKey:@"appearAnimation"];
    }
}

- (IBAction)doubleTap:(UITapGestureRecognizer *)sender {
    [upperView.layer addAnimation:[Animator flash] forKey:@"flashAnimation"];
    NSLog(@"Snap on: %@", currentLocation);
    
    UIGraphicsBeginImageContext(map.frame.size);
    [map.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *mapImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    CLLocation *locationToSave = currentLocation;
    
    NSData *mapData = UIImagePNGRepresentation(mapImage);
    [mapData writeToFile:[NSString stringWithFormat:@"%@/%.0f.png", [Library applicationDocumentsDirectory], locationToSave.timestamp.timeIntervalSince1970] atomically:YES];
    
    [[[Library sharedLibrary] elements] addObject:locationToSave];
    
    [[Library sharedLibrary] save];
}

- (IBAction)trippleTap:(UITapGestureRecognizer *)sender {
    if (!recording) {
        // Start recording
        recording = YES;
        [recordDot.layer addAnimation:[Animator blink] forKey:@"blinkAnimation"];
        [self.view.layer addAnimation:[Animator borderBlink] forKey:@"borderBlinkAnimation"];
    }
    else{
        // Stop recording
        recording = NO;
        [recordDot.layer removeAllAnimations];
        [self.view.layer removeAllAnimations];
    }
    swipeUp.enabled = doubleTap.enabled = !recording;
}
@end
