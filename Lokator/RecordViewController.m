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

@implementation RecordViewController

- (void)viewDidLoad{
    recording = NO;
    
    [recordDot.layer setCornerRadius:8];
    [upperView.layer setOpacity:0];
    
    [recordDot setBackgroundColor:[UIColor colorWithCSS:@"#EE0000"]];
    [self.view.layer setBorderWidth:5];
    [self.view.layer setBorderColor:[UIColor clearColor].CGColor];
    
    [doubleTap requireGestureRecognizerToFail:trippleTap];

    [super viewDidLoad];
}

- (IBAction)doubleTap:(UITapGestureRecognizer *)sender {
    if (!recording) {
        CABasicAnimation *flash = [CABasicAnimation animationWithKeyPath:@"opacity"];
        flash.fromValue = [NSNumber numberWithFloat:0.0];
        flash.toValue = [NSNumber numberWithFloat:1.0];
        flash.duration = .125;        // 1 second
        flash.autoreverses = YES;    // Back
        
        [upperView.layer addAnimation:flash forKey:@"flashAnimation"];
    }
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
