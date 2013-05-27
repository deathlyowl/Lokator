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
    return [[Library sharedLibrary] elements].count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                 cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    MapCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Label"
                                                                           forIndexPath:indexPath];
    
    CLLocation *location = [[[Library sharedLibrary] elements] objectAtIndex:[Library.sharedLibrary.elements count] - indexPath.row - 1];
    
    [cell.image setImage:[UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%.0f.png", [Library applicationDocumentsDirectory], location.timestamp.timeIntervalSince1970]]];
    [cell.icon setCornerRadius:24];
    [cell.icon setMaskFromImage:[UIImage imageNamed:@"marker.png"]];
    
    return cell;
}


@end
