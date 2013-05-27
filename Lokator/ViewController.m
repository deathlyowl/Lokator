//
//  ViewController.m
//  Lokator
//
//  Created by Paweł Ksieniewicz on 27.05.2013.
//  Copyright (c) 2013 Paweł Ksieniewicz. All rights reserved.
//

#import "ViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "UIColor+Hex.h"
#import "MapCell.h"

@implementation ViewController

- (void)viewDidLoad
{
    [self customLoadings];
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void) customLoadings{
    CALayer *circle = [CALayer layer];
    [circle setBounds:CGRectMake(0, 0, 64, 64)];
    [circle setAnchorPoint:CGPointMake(.5, .5)];
    [circle setPosition:CGPointMake(32, 32)];
    [circle setBackgroundColor:[UIColor colorWithCSS:@"#EE0000"].CGColor];
    [circle setCornerRadius:32];
    
    CALayer *foot = [CALayer layer];
    [foot setBounds:CGRectMake(0, 0, 32, 32)];
    [foot setAnchorPoint:CGPointMake(0, 0)];
    [foot setPosition:CGPointMake(32, 32)];
    [foot setBackgroundColor:[UIColor colorWithCSS:@"#EE0000"].CGColor];
    
    
    CALayer *dot = [CALayer layer];
    [dot setBounds:CGRectMake(0, 0, 16, 16)];
    [dot setAnchorPoint:CGPointMake(.5, .5)];
    [dot setPosition:CGPointMake(32, 32)];
    [dot setBackgroundColor:[UIColor colorWithCSS:@"#FFEEEE"].CGColor];
    [dot setCornerRadius:8];
    
    
    [circle addSublayer:foot];
    [circle addSublayer:dot];
    
    circle.transform = CATransform3DMakeRotation(M_PI_4, 0, 0, 1);
    
    
    [recordButton.layer addSublayer:circle];
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 12;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                 cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    MapCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Label"
                                                                           forIndexPath:indexPath];
    
    [cell.image setImage:[UIImage imageNamed:@"map"]];
    
    [cell.icon.layer setCornerRadius:24];
    
    // Create your mask layer
    CALayer* maskLayer = [CALayer layer];
    maskLayer.frame = CGRectMake(0,0,48 ,48);
    maskLayer.contents = (__bridge id)[[UIImage imageNamed:@"marker.png"] CGImage];
    
    // Apply the mask to your uiview layer
    cell.icon.layer.mask = maskLayer;
    
    return cell;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)record:(id)sender {
    NSLog(@"Record!");
   /*
    MKMapPoint mapPoint = MKMapPointForCoordinate(CLLocationCoordinate2DMake(53.95, 14.3));
    
//    MKMapView *map = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, 300, 300)];
    
    [map setVisibleMapRect:MKMapRectMake(mapPoint.x, mapPoint.y, 100000, 100000) animated:NO];
    
    
    UIGraphicsBeginImageContext(map.frame.size);
    [map.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *mapImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    NSData *mapData = UIImagePNGRepresentation(mapImage);
    [mapData writeToFile:@"/Users/xehivs/Desktop/map.png" atomically:YES];
    */
}


@end
