//
//  DGHProductInfoViewController.h
//  DeviceGH
//
//  Created by Sreelash S on 25/01/15.
//  Copyright (c) 2015 Sreelal H. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Product.h"
#import "ProductInfo.h"

@interface DGHProductInfoViewController : UIViewController {
    
    IBOutlet UIImageView           *productImageView;
    IBOutlet UILabel               *productNameLabel;
    IBOutlet UIButton              *addToEnquiryBtn;
    IBOutlet UISegmentedControl    *segmentControl;
    IBOutlet UIWebView             *specificationWebView;
    IBOutlet UIWebView             *descriptionWebView;
}

@property (nonatomic, strong) Product *product;
@property (nonatomic, strong) ProductInfo *productInfo;

@end
