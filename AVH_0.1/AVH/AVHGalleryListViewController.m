//
//  AVHGalleryViewController.m
//  AVH
//
//  Created by Sreelash S on 06/06/15.
//  Copyright (c) 2015 Sreelal H. All rights reserved.
//

#import "AVHGalleryListViewController.h"
#import "HelperClass.h"
#import "AppDelegate.h"
#import "WebHandler.h"
#import "AVHHotelInfoListCell.h"
#import "SDImageCache.h"
#import "MWCommon.h"

@interface AVHGalleryListViewController ()

@property (nonatomic, assign) BOOL isViewPopped;

@property (nonatomic, strong) NSMutableArray *galleries;

@end

@implementation AVHGalleryListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
        
    // Clear cache for testing
//    [[SDImageCache sharedImageCache] clearDisk];
//    [[SDImageCache sharedImageCache] clearMemory];

    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"AVH_logo.png"]];
    
    UIBarButtonItem *leftBarItem = [HelperClass getBackButtonItemWithTarget:self andAction:@selector(navgationBackClicked:)];
    leftBarItem.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = leftBarItem;
    
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    
    [[AppDelegate instance] showBusyView:@"Loading Gallery..."];
    
    [WebHandler getGalleryInfoWithCallback:^(id object, NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (object) {
                _galleries = object;
                [infoTableView reloadData];
            }
            
            [[AppDelegate instance] hideBusyView];
        });
    }];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    if (_isViewPopped)
        [[self navigationController] setNavigationBarHidden:YES animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Button Actions

- (void)navgationBackClicked:(id)sender {
    
    _isViewPopped = YES;
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - TableView Delegates & Datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _galleries.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *infoDict = _galleries[indexPath.row];
    
    static NSString *cellId = @"hotelInfoCell";
    AVHHotelInfoListCell *hotelInfoCell = (AVHHotelInfoListCell *)[tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
    hotelInfoCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    hotelInfoCell.title.text = infoDict[@"name"];
    
    NSArray *images = infoDict[@"images"];
    
    [hotelInfoCell loadInfoImageWithURL:[images firstObject]];
    
    return hotelInfoCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSArray *images = (NSArray *)_galleries[indexPath.row][@"images"];
    
    __block NSMutableArray *photos = [[NSMutableArray alloc] init];
    __block NSMutableArray *thumbs = [[NSMutableArray alloc] init];
    
    BOOL displayActionButton = YES;
    BOOL displaySelectionButtons = NO;
    BOOL displayNavArrows = NO;
    BOOL enableGrid = YES;
    BOOL startOnGrid = NO;
    
    [images enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *imageURL = (NSString *)obj;
        
        [photos addObject:[MWPhoto photoWithURL:[NSURL URLWithString:imageURL]]];
        [thumbs addObject:[MWPhoto photoWithURL:[NSURL URLWithString:imageURL]]];
    }];
    
    /*[photos addObject:[MWPhoto photoWithURL:[NSURL URLWithString:@"http://farm4.static.flickr.com/3567/3523321514_371d9ac42f_b.jpg"]]];
    [photos addObject:[MWPhoto photoWithURL:[NSURL URLWithString:@"http://farm4.static.flickr.com/3629/3339128908_7aecabc34b_b.jpg"]]];
    [photos addObject:[MWPhoto photoWithURL:[NSURL URLWithString:@"http://farm4.static.flickr.com/3364/3338617424_7ff836d55f_b.jpg"]]];
    [photos addObject:[MWPhoto photoWithURL:[NSURL URLWithString:@"http://farm4.static.flickr.com/3590/3329114220_5fbc5bc92b_b.jpg"]]];
    [photos addObject:[MWPhoto photoWithURL:[NSURL URLWithString:@"http://farm3.static.flickr.com/2449/4052876281_6e068ac860_b.jpg"]]];
    // Thumbs
    [thumbs addObject:[MWPhoto photoWithURL:[NSURL URLWithString:@"http://farm4.static.flickr.com/3567/3523321514_371d9ac42f_q.jpg"]]];
    [thumbs addObject:[MWPhoto photoWithURL:[NSURL URLWithString:@"http://farm4.static.flickr.com/3629/3339128908_7aecabc34b_q.jpg"]]];
    [thumbs addObject:[MWPhoto photoWithURL:[NSURL URLWithString:@"http://farm4.static.flickr.com/3364/3338617424_7ff836d55f_q.jpg"]]];
    [thumbs addObject:[MWPhoto photoWithURL:[NSURL URLWithString:@"http://farm4.static.flickr.com/3590/3329114220_5fbc5bc92b_q.jpg"]]];
    [thumbs addObject:[MWPhoto photoWithURL:[NSURL URLWithString:@"http://farm3.static.flickr.com/2449/4052876281_6e068ac860_q.jpg"]]];*/
    
    self.photos = photos;
    self.thumbs = thumbs;
    
    // Create browser
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    browser.displayActionButton = displayActionButton;
    browser.displayNavArrows = displayNavArrows;
    browser.displaySelectionButtons = displaySelectionButtons;
    browser.alwaysShowControls = displaySelectionButtons;
    browser.zoomPhotosToFill = YES;
#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_7_0
    browser.wantsFullScreenLayout = YES;
#endif
    browser.enableGrid = enableGrid;
    browser.startOnGrid = startOnGrid;
    browser.enableSwipeToDismiss = YES;
    [browser setCurrentPhotoIndex:0];
    
    [browser reloadData];
    
    [self.navigationController pushViewController:browser animated:YES];
}

#pragma mark - MWPhotoBrowserDelegate

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return _photos.count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < _photos.count)
        return [_photos objectAtIndex:index];
    return nil;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser thumbPhotoAtIndex:(NSUInteger)index {
    if (index < _thumbs.count)
        return [_thumbs objectAtIndex:index];
    return nil;
}

//- (MWCaptionView *)photoBrowser:(MWPhotoBrowser *)photoBrowser captionViewForPhotoAtIndex:(NSUInteger)index {
//    MWPhoto *photo = [self.photos objectAtIndex:index];
//    MWCaptionView *captionView = [[MWCaptionView alloc] initWithPhoto:photo];
//    return [captionView autorelease];
//}

//- (void)photoBrowser:(MWPhotoBrowser *)photoBrowser actionButtonPressedForPhotoAtIndex:(NSUInteger)index {
//    NSLog(@"ACTION!");
//}

//- (void)photoBrowser:(MWPhotoBrowser *)photoBrowser didDisplayPhotoAtIndex:(NSUInteger)index {
//    NSLog(@"Did start viewing photo at index %lu", (unsigned long)index);
//}

//- (BOOL)photoBrowser:(MWPhotoBrowser *)photoBrowser isPhotoSelectedAtIndex:(NSUInteger)index {
//    return [[_selections objectAtIndex:index] boolValue];
//}

//- (NSString *)photoBrowser:(MWPhotoBrowser *)photoBrowser titleForPhotoAtIndex:(NSUInteger)index {
//    return [NSString stringWithFormat:@"Photo %lu", (unsigned long)index+1];
//}

//- (void)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index selectedChanged:(BOOL)selected {
//    //[_selections replaceObjectAtIndex:index withObject:[NSNumber numberWithBool:selected]];
//    NSLog(@"Photo at index %lu selected %@", (unsigned long)index, selected ? @"YES" : @"NO");
//}

//- (void)photoBrowserDidFinishModalPresentation:(MWPhotoBrowser *)photoBrowser {
//    // If we subscribe to this method we must dismiss the view controller ourselves
//    NSLog(@"Did finish modal presentation");
//    [self dismissViewControllerAnimated:YES completion:nil];
//}

@end
