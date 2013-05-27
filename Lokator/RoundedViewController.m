//
//  RoundedViewController.m
//  Lokator
//
//  Created by Paweł Ksieniewicz on 27.05.2013.
//  Copyright (c) 2013 Paweł Ksieniewicz. All rights reserved.
//

#import "RoundedViewController.h"
#import <QuartzCore/QuartzCore.h>

@implementation RoundedViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    [self.view setCornerRadius:32];
}

- (IBAction)dismiss:(id)sender { [self dismissViewControllerAnimated:YES completion:nil]; }

@end