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
    return 30;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                 cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Label"
                                                                           forIndexPath:indexPath];
    return cell;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)record:(id)sender {
    NSLog(@"Record!");
}


@end
