//
//  Animator.m
//  Lokator
//
//  Created by Paweł Ksieniewicz on 27.05.2013.
//  Copyright (c) 2013 Paweł Ksieniewicz. All rights reserved.
//

#import "Animator.h"

@implementation Animator


+ (CABasicAnimation *)drawerDisappear{
    CABasicAnimation *appear = [CABasicAnimation animationWithKeyPath:@"opacity"];
    appear.fromValue = [NSNumber numberWithFloat:1];
    appear.toValue = [NSNumber numberWithFloat:0];
    appear.duration = .5;        // 1 second
    appear.autoreverses = NO;    // Back
    appear.repeatCount = 1;
    
    return appear;
}

+ (CABasicAnimation *)drawerAppear{
    CABasicAnimation *appear = [CABasicAnimation animationWithKeyPath:@"opacity"];
    appear.fromValue = [NSNumber numberWithFloat:0];
    appear.toValue = [NSNumber numberWithFloat:1];
    appear.duration = .5;        // 1 second
    appear.autoreverses = NO;    // Back
    appear.repeatCount = 1;
    
    return appear;
}

+ (CABasicAnimation *)appear{
    CABasicAnimation *appear = [CABasicAnimation animationWithKeyPath:@"opacity"];
    appear.fromValue = [NSNumber numberWithFloat:0];
    appear.toValue = [NSNumber numberWithFloat:.9];
    appear.duration = 1;        // 1 second
    appear.autoreverses = NO;    // Back
    appear.repeatCount = 1;
    
    return appear;
}

+ (CABasicAnimation *)disappear{
    CABasicAnimation *disappear = [CABasicAnimation animationWithKeyPath:@"opacity"];
    disappear.fromValue = [NSNumber numberWithFloat:1.0];
    disappear.toValue = [NSNumber numberWithFloat:0.15];
    disappear.duration = 1;        // 1 second
    disappear.autoreverses = NO;    // Back
    disappear.repeatCount = 1;
    
    return disappear;
}

+ (CABasicAnimation *)flash{
    CABasicAnimation *flash = [CABasicAnimation animationWithKeyPath:@"opacity"];
    flash.fromValue = [NSNumber numberWithFloat:0.0];
    flash.toValue = [NSNumber numberWithFloat:1.0];
    flash.duration = .125;        // 1 second
    flash.autoreverses = YES;    // Back
    
    return flash;
}


+ (CABasicAnimation *)blink{
    CABasicAnimation *blink = [CABasicAnimation animationWithKeyPath:@"opacity"];
    blink.fromValue = [NSNumber numberWithFloat:0.0];
    blink.toValue = [NSNumber numberWithFloat:1.0];
    blink.duration = .5;        // 1 second
    blink.autoreverses = YES;    // Back
    blink.repeatCount = 999999;
    
    return blink;
}

+ (CABasicAnimation *)borderBlink{
    CABasicAnimation *borderBlink = [CABasicAnimation animationWithKeyPath:@"borderColor"];
    borderBlink.fromValue = (__bridge id)([UIColor clearColor].CGColor);
    borderBlink.toValue = (__bridge id)([UIColor colorWithCSS:@"#EE0000"].CGColor);
    borderBlink.duration = .5;        // 1 second
    borderBlink.autoreverses = YES;    // Back
    borderBlink.repeatCount = 999999;
    
    return borderBlink;
}

@end
