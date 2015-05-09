//
//  DGHCategoryCollectionViewCell.h
//  DeviceGH
//
//  Created by Sreelash S on 17/01/15.
//  Copyright (c) 2015 Sreelal H. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductCategory.h"

@interface DGHCategoryCollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView     *activity;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UILabel     *categoryNameLabel;

- (void)setupBg;
- (void)loadCategoryImageForCategory:(ProductCategory *)category;

@end
