//
//  UIView+MagicViews.m
//  Lokator
//
//  Created by Paweł Ksieniewicz on 27.05.2013.
//  Copyright (c) 2013 Paweł Ksieniewicz. All rights reserved.
//

#import "UIView+MagicViews.h"

@implementation UIView (MagicViews)

- (void) setCornerRadius:(float)radius{
    self.layer.cornerRadius = radius;
    self.clipsToBounds = YES;
}

- (void)setBorderWidth:(float)width
              andColor:(UIColor *)color{
    [self.layer setBorderWidth:width];
    [self.layer setBorderColor:color.CGColor];
}

- (void)setMaskFromImage:(UIImage *)image{
    CALayer* maskLayer = [CALayer layer];
    maskLayer.frame = CGRectMake(0, 0, image.size.width, image.size.height);
    maskLayer.contents = (__bridge id)[image CGImage];
    self.layer.mask = maskLayer;
}


@end
