//
//  ViewController.m
//  Lokator
//
//  Created by Paweł Ksieniewicz on 27.05.2013.
//  Copyright (c) 2013 Paweł Ksieniewicz. All rights reserved.
//

#import "ListViewController.h"
#import "MapCell.h"

@implementation ListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view.layer setBorderColor:[UIColor colorWithWhite:.5 alpha:.5].CGColor];
    [self.view.layer setBorderWidth:5];    
}

#pragma mark -
#pragma mark Collection

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 3;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                 cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    MapCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Label"
                                                                           forIndexPath:indexPath];
    
    [cell.image setImage:[UIImage imageNamed:@"map"]];
    [cell.icon setCornerRadius:24];
    
    switch (rand()%2) {
        case 0:
            [cell.icon setMaskFromImage:[UIImage imageNamed:@"marker.png"]];
            break;
        default:
            [cell.icon setMaskFromImage:[UIImage imageNamed:@"mapMarker.png"]];
            break;
    }
    
    return cell;
}


@end
