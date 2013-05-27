//
//  MapCell.h
//  Lokator
//
//  Created by Paweł Ksieniewicz on 27.05.2013.
//  Copyright (c) 2013 Paweł Ksieniewicz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface MapCell : UICollectionViewCell

@property (nonatomic, retain) IBOutlet UIView *icon;
@property (nonatomic, retain) IBOutlet UIImageView *image;

@end
