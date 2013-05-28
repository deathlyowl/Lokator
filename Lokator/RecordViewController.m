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
    locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
    
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
        
        if (recording) {
            [record addObject:newLocation];
            NSLog(@"Recorded items: %i", record.count);
        }
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
        
        [[[Library sharedLibrary] elements] addObject:record];
        
        [[Library sharedLibrary] save];
        
    }
    swipeUp.enabled = doubleTap.enabled = !recording;
}
@end
