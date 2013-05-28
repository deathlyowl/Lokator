//
//  Animator.h
//  Lokator
//
//  Created by Paweł Ksieniewicz on 27.05.2013.
//  Copyright (c) 2013 Paweł Ksieniewicz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

@interface Animator : NSObject

+ (CABasicAnimation *) appear;
+ (CABasicAnimation *) drawerAppear;
+ (CABasicAnimation *) drawerDisappear;
+ (CABasicAnimation *) disappear;
+ (CABasicAnimation *) flash;
+ (CABasicAnimation *) blink;
+ (CABasicAnimation *) borderBlink;

@end