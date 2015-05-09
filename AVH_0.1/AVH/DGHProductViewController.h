//
//  DGHProductViewController.h
//  DeviceGH
//
//  Created by Sreelash S on 19/01/15.
//  Copyright (c) 2015 Sreelal H. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductCategory.h"


@interface DGHProductViewController : UIViewController {
    
    IBOutlet UICollectionView *productsCollectionView;
}

@property (assign, nonatomic) BOOL isEnquiry;

@property (assign, nonatomic) BOOL isProductSearch;

@property (strong, nonatomic) NSMutableArray  *products;

@property (strong, nonatomic) ProductCategory *category;


@end
