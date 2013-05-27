//
//  UIView+MagicViews.h
//  Lokator
//
//  Created by Paweł Ksieniewicz on 27.05.2013.
//  Copyright (c) 2013 Paweł Ksieniewicz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface UIView (MagicViews)

- (void) setCornerRadius:(float)radius;
- (void) setBorderWidth:(float)width
               andColor:(UIColor *)color;

- (void) setMaskFromImage:(UIImage *)image;

@end
