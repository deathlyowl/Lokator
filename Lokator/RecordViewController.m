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
    scale = 2;
    
    [super viewDidLoad];
    
    recording = NO;
    firstLocation = YES;
    
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
    locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
    
    [locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{    
    if ([newLocation distanceFromLocation:oldLocation]) {
        currentLocation = newLocation;
        [self relocate];
        if (recording) {
            [record addObject:newLocation];
            [self drawRoute];
        }
    }
}


- (IBAction)zoomIn:(id)sender {
    scale++;
    if (scale > 6) scale = 6;
    [self relocate];
}

- (IBAction)zoomOut:(id)sender {
    scale--;
    if (scale < 0) scale = 0;
    [self relocate];
}

- (void) relocate{
    MKMapPoint mapPoint = MKMapPointForCoordinate(currentLocation.coordinate);
    
    [map setVisibleMapRect:MKMapRectMake(mapPoint.x-zoomWithScale(scale)/2, mapPoint.y-zoomWithScale(scale)/2, zoomWithScale(scale), zoomWithScale(scale))
                  animated:!firstLocation];
    firstLocation = NO;
}

int zoomWithScale(int scale) {
    switch (scale) {
        case 0: return 2500;
        case 1: return 5000;
        case 2: return 10000;
        case 3: return 20000;
        case 4: return 40000;
        case 5: return 80000;
        case 6: return 85000;
    }
    return 10000;
}

- (void) drawRoute
{
    NSArray *overlaysBefore = [map.overlays copy];
    
    
    NSInteger numberOfSteps = record.count;
    
    CLLocationCoordinate2D coordinates[numberOfSteps];
    for (NSInteger index = 0; index < numberOfSteps; index++) {
        CLLocation *location = [record objectAtIndex:index];
        CLLocationCoordinate2D coordinate = location.coordinate;
        
        coordinates[index] = coordinate;
    }
    
    MKPolyline *polyLine = [MKPolyline polylineWithCoordinates:coordinates count:numberOfSteps];
    [map addOverlay:polyLine];
    [map removeOverlays:overlaysBefore];
    
}

- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay {
    MKPolylineView *polylineView = [[MKPolylineView alloc] initWithPolyline:overlay];
    polylineView.strokeColor = [UIColor colorWithCSS:@"#EE0000"];
    polylineView.lineWidth = 3.0;
    
    return polylineView;
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
    locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    
    [upperView.layer addAnimation:[Animator flash] forKey:@"flashAnimation"];
    NSLog(@"Snap on: %@", currentLocation);
    
    UIGraphicsBeginImageContext(map.frame.size);
    
    [map.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *mapImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    CGImageRef imageRef = CGImageCreateWithImageInRect([mapImage CGImage], CGRectMake(160-80, 240-40, 160, 80));
    CGImageRef largeImageRef = CGImageCreateWithImageInRect([mapImage CGImage], CGRectMake(160-150, 240-130, 300, 260));
    
    CLLocation *locationToSave = currentLocation;
    
    NSData *mapData = UIImagePNGRepresentation([UIImage imageWithCGImage:imageRef]);
    NSData *largeMapData = UIImagePNGRepresentation([UIImage imageWithCGImage:largeImageRef]);
    [mapData writeToFile:[NSString stringWithFormat:@"%@/%.0f.png", [Library applicationDocumentsDirectory], locationToSave.timestamp.timeIntervalSince1970] atomically:YES];
    [largeMapData writeToFile:[NSString stringWithFormat:@"%@/%.0f_big.png", [Library applicationDocumentsDirectory], locationToSave.timestamp.timeIntervalSince1970] atomically:YES];
    
    CGImageRelease(imageRef);
    
    [[[Library sharedLibrary] elements] addObject:locationToSave];
    
    [[Library sharedLibrary] save];
}

- (IBAction)trippleTap:(UITapGestureRecognizer *)sender {
    if (!recording) {
        record = [[NSMutableArray alloc] init];
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
        // Start recording
        [recordDot.layer addAnimation:[Animator blink] forKey:@"blinkAnimation"];
        [self.view.layer addAnimation:[Animator borderBlink] forKey:@"borderBlinkAnimation"];
        recording = YES;
    }
    else{
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
        // Stop recording

        recording = NO;
        [recordDot.layer removeAllAnimations];
        [self.view.layer removeAllAnimations];
        
        NSLog(@"Saving record with %i items.", record.count);
        
        UIGraphicsBeginImageContext(map.frame.size);
        
        [map.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *mapImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        CGImageRef imageRef = CGImageCreateWithImageInRect([mapImage CGImage], CGRectMake(160-80, 240-40, 160, 80));
        CGImageRef largeImageRef = CGImageCreateWithImageInRect([mapImage CGImage], CGRectMake(160-150, 240-130, 300, 260));
        
        CLLocation *locationToSave = [record lastObject];
        
        NSData *mapData = UIImagePNGRepresentation([UIImage imageWithCGImage:imageRef]);
        NSData *largeMapData = UIImagePNGRepresentation([UIImage imageWithCGImage:largeImageRef]);
        [mapData writeToFile:[NSString stringWithFormat:@"%@/%.0f.png", [Library applicationDocumentsDirectory], locationToSave.timestamp.timeIntervalSince1970] atomically:YES];
        [largeMapData writeToFile:[NSString stringWithFormat:@"%@/%.0f_big.png", [Library applicationDocumentsDirectory], locationToSave.timestamp.timeIntervalSince1970] atomically:YES];
        
        CGImageRelease(imageRef);
        
        
        [map removeOverlays:map.overlays];
        
        [[[Library sharedLibrary] elements] addObject:record];
        
        [[Library sharedLibrary] save];
        
    }
    swipeUp.enabled = doubleTap.enabled = !recording;
}

@end
