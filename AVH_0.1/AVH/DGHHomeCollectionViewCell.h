//
//  DGHHomeCollectionViewCell.h
//  DeviceGH
//
//  Created by Sreelash S on 21/12/14.
//  Copyright (c) 2014 Sreelal H. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductCategory.h"

@interface DGHHomeCollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UIImageView *iconImageView;
@property (strong, nonatomic) IBOutlet UILabel     *titleLabel;

- (void)setupBg;
- (void)loadCategoryImageForCategory:(ProductCategory *)category;

@end
