//
//  ViewController.m
//  Lokator
//
//  Created by Paweł Ksieniewicz on 27.05.2013.
//  Copyright (c) 2013 Paweł Ksieniewicz. All rights reserved.
//

#import "ListViewController.h"
#import "MapCell.h"
#import "Animator.h"
#import <GPX/GPX.h>

@implementation ListViewController

- (void)viewDidLoad
{
    isDrawerOpen = NO;
    
    [self.drawerIcon setCornerRadius:24];
    
    [super viewDidLoad];
    [self.view.layer setBorderColor:[UIColor colorWithWhite:.5 alpha:.5].CGColor];
    [self.view.layer setBorderWidth:5];
    
    
    [self.drawerView.layer setBorderColor:[UIColor colorWithWhite:1 alpha:.5].CGColor];
    [self.drawerView.layer setBorderWidth:5];
    [self.drawerView setCornerRadius:24];
}

#pragma mark -
#pragma mark Collection

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [[Library sharedLibrary] elements].count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)_collectionView
                 cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    MapCell *cell = [_collectionView dequeueReusableCellWithReuseIdentifier:@"Label"
                                                                           forIndexPath:indexPath];
    
    id item = [[[Library sharedLibrary] elements] objectAtIndex:[Library.sharedLibrary.elements count] - indexPath.row - 1];
    
    CLLocation *location;
    if ([item isKindOfClass:[CLLocation class]]) {
        location = item;
        [cell.icon setMaskFromImage:[UIImage imageNamed:@"marker.png"]];
    }
    else {
        location = [item lastObject];
        [cell.icon setMaskFromImage:[UIImage imageNamed:@"mapMarker.png"]];
    }
    
    [cell.image setImage:[UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%.0f.png", [Library applicationDocumentsDirectory], location.timestamp.timeIntervalSince1970]]];
    [cell.icon setCornerRadius:24];
        
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (!isDrawerOpen) {
        selectedItem = [[[Library sharedLibrary] elements] objectAtIndex:[Library.sharedLibrary.elements count] - indexPath.row - 1];

        GPXRoot *root = [GPXRoot rootWithCreator:@"Lokator"];

        CLLocation *location;
        if ([selectedItem isKindOfClass:[CLLocation class]]) {
            [self.drawerIcon setMaskFromImage:[UIImage imageNamed:@"marker.png"]];
            location = selectedItem;
            
            GPXWaypoint *waypoint = [root newWaypointWithLatitude:location.coordinate.latitude longitude:location.coordinate.longitude];
            waypoint.time = location.timestamp;
        }
        else {
            [self.drawerIcon setMaskFromImage:[UIImage imageNamed:@"mapMarker.png"]];
            location = [selectedItem lastObject];
                        
            for (CLLocation *location in selectedItem) {
                GPXWaypoint *waypoint = [root newWaypointWithLatitude:location.coordinate.latitude longitude:location.coordinate.longitude];
                waypoint.time = location.timestamp;
            }
        }
        
        gpx = root.gpx;

        [drawerMap setImage:[UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%.0f_big.png", [Library applicationDocumentsDirectory], location.timestamp.timeIntervalSince1970]]];

        isDrawerOpen = YES;
        
        [self.drawerView.layer addAnimation:[Animator drawerAppear] forKey:@"drawerAppearAnimation"];
        self.drawerView.layer.opacity = 1;
    }
}


- (IBAction)hideDrawer:(id)sender {
    if (isDrawerOpen) {
        
        isDrawerOpen = NO;
        
        [self.drawerView.layer addAnimation:[Animator drawerDisappear] forKey:@"drawerDisappearAnimation"];
        self.drawerView.layer.opacity = 0;
    }
}

- (IBAction)destroy:(id)sender {
    [[[Library sharedLibrary] elements] removeObject:selectedItem];
    [[Library sharedLibrary] save];
    
    CLLocation *location;
    
    if ([selectedItem isKindOfClass:[CLLocation class]]) location = selectedItem;
    else location = [selectedItem lastObject];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager removeItemAtPath:[NSString stringWithFormat:@"%@/%.0f_big.png", [Library applicationDocumentsDirectory], location.timestamp.timeIntervalSince1970] error:nil];
    [fileManager removeItemAtPath:[NSString stringWithFormat:@"%@/%.0f.png", [Library applicationDocumentsDirectory], location.timestamp.timeIntervalSince1970] error:nil];
    
    
    [collectionView reloadData];
    [self hideDrawer:sender];
}

- (IBAction)share:(id)sender {
    NSString *tsv = @"";
    if (![selectedItem isKindOfClass:[CLLocation class]])
        for (CLLocation *location in selectedItem)
            tsv = [tsv stringByAppendingFormat:@"%f\t%f\t%i\n", location.coordinate.latitude, location.coordinate.longitude, (int)location.timestamp.timeIntervalSince1970];
    
    MFMailComposeViewController *mailComposer = [[MFMailComposeViewController alloc] init];
        
    [mailComposer addAttachmentData:[gpx dataUsingEncoding:NSUTF8StringEncoding]
                           mimeType:@"application/gpx+xml"
                           fileName:@"data.gpx"];
    
    [mailComposer addAttachmentData:[tsv dataUsingEncoding:NSUTF8StringEncoding]
                           mimeType:@"text/tab-separated-values"
                           fileName:@"data.tsv"];
    
    /* Set default subject */
    [mailComposer setSubject:@"Dane GPX"];
    
    mailComposer.mailComposeDelegate = self;
    
    [self presentViewController:mailComposer
                       animated:YES
                     completion:nil];    
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled: you cancelled the operation and no email message was queued.");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved: you saved the email message in the drafts folder.");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail send: the email message is queued in the outbox. It is ready to send.");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail failed: the email message was not saved or queued, possibly due to an error.");
            break;
        default:
            NSLog(@"Mail not sent.");
            break;
    }
    // Remove the mail view
    [controller dismissViewControllerAnimated:YES
                                   completion:nil];
}

@end
