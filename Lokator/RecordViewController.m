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
    recording = NO;
    
    [self.view setBorderWidth:5
                     andColor:[UIColor clearColor]];
    
    [recordDot setCornerRadius:8];
    [recordDot setBackgroundColor:[UIColor colorWithCSS:@"#EE0000"]];
    
    [splash setMaskFromImage:[UIImage imageNamed:@"marker.png"]];
    [splash setCornerRadius:24];
    
    [doubleTap requireGestureRecognizerToFail:trippleTap];
    
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    // Hide icon
    if (!animated) [splash.layer addAnimation:[Animator disappear] forKey:@"disappearAnimation"];
}

- (IBAction)doubleTap:(UITapGestureRecognizer *)sender {
    [upperView.layer addAnimation:[Animator flash] forKey:@"flashAnimation"];
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
