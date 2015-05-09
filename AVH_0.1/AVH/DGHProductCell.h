//
//  DGHProductCell.h
//  DeviceGH
//
//  Created by Sreelash S on 20/01/15.
//  Copyright (c) 2015 Sreelal H. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Product.h"

@protocol ProductCellDelegate <NSObject>

@optional
- (void)addProductToEnquireList:(Product *)product;
- (void)deleteProductFromEnquireList:(Product *)product;
- (void)viewProductInfo:(Product *)product;
@end

@interface DGHProductCell : UICollectionViewCell

@property (nonatomic, weak) id <ProductCellDelegate> delegate;

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView     *activity;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UILabel     *productNameLabel;
@property (strong, nonatomic) IBOutlet UIButton    *enquiryBtn;
@property (strong, nonatomic) IBOutlet UIButton    *removeBtn;
@property (strong, nonatomic) IBOutlet UIButton    *infoBtn;

- (void)setupBg;
- (void)loadProductImageForProduct:(Product *)product ;

@end
