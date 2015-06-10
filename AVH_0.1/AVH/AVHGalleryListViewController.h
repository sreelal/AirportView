//
//  AVHGalleryViewController.h
//  AVH
//
//  Created by Sreelash S on 06/06/15.
//  Copyright (c) 2015 Sreelal H. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MWPhotoBrowser.h"

@interface AVHGalleryListViewController : UIViewController <MWPhotoBrowserDelegate> {
    IBOutlet UITableView *infoTableView;
}

@property (nonatomic, assign) BOOL isFromMenu;

@property (nonatomic, strong) NSMutableArray *photos;
@property (nonatomic, strong) NSMutableArray *thumbs;

@end
