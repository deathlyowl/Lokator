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
    
    [recordDot.layer setCornerRadius:8];
    [upperView.layer setOpacity:0];
    
    [recordDot setBackgroundColor:[UIColor colorWithCSS:@"#EE0000"]];
    [self.view.layer setBorderWidth:5];
    [self.view.layer setBorderColor:[UIColor clearColor].CGColor];
    
    [doubleTap requireGestureRecognizerToFail:trippleTap];
    
    
    // Create your mask layer
    CALayer* maskLayer = [CALayer layer];
    maskLayer.frame = CGRectMake(0,0,48 ,48);
    maskLayer.contents = (__bridge id)[[UIImage imageNamed:@"marker.png"] CGImage];
    
    // Apply the mask to your uiview layer
    splash.layer.mask = maskLayer;
    splash.layer.cornerRadius = 24;
    

    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    if (!animated) {
        splash.layer.opacity = 0;
        [splash.layer addAnimation:[Animator disappear] forKey:@"disappearAnimation"];
    }
    
}

- (IBAction)doubleTap:(UITapGestureRecognizer *)sender {
    if (!recording) [upperView.layer addAnimation:[Animator flash]
                                           forKey:@"flashAnimation"];
}

- (IBAction)trippleTap:(UITapGestureRecognizer *)sender {
    if (!recording) {
        recording = YES;
        swipeUp.enabled = NO;
        CABasicAnimation *blink = [CABasicAnimation animationWithKeyPath:@"opacity"];
        blink.fromValue = [NSNumber numberWithFloat:0.0];
        blink.toValue = [NSNumber numberWithFloat:1.0];
        blink.duration = .5;        // 1 second
        blink.autoreverses = YES;    // Back
        blink.repeatCount = 999999;
        
        
        
        CABasicAnimation *borderBlink = [CABasicAnimation animationWithKeyPath:@"borderColor"];
        borderBlink.fromValue = (__bridge id)([UIColor clearColor].CGColor);
        borderBlink.toValue = (__bridge id)([UIColor colorWithCSS:@"#EE0000"].CGColor);
        borderBlink.duration = .5;        // 1 second
        borderBlink.autoreverses = YES;    // Back
        borderBlink.repeatCount = 999999;
        
        [recordDot.layer addAnimation:blink forKey:@"blinkAnimation"];
        [self.view.layer addAnimation:borderBlink forKey:@"borderBlinkAnimation"];
    }
    else{
        recording = NO;
        swipeUp.enabled = YES;
        [recordDot.layer removeAllAnimations];
        [self.view.layer removeAllAnimations];
    }
}
@end
