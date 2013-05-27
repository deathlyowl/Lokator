//
//  Animator.m
//  Lokator
//
//  Created by Paweł Ksieniewicz on 27.05.2013.
//  Copyright (c) 2013 Paweł Ksieniewicz. All rights reserved.
//

#import "Animator.h"

@implementation Animator

+ (CABasicAnimation *)disappear{
    CABasicAnimation *disappear = [CABasicAnimation animationWithKeyPath:@"opacity"];
    disappear.fromValue = [NSNumber numberWithFloat:1.0];
    disappear.toValue = [NSNumber numberWithFloat:0.0];
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

@end
