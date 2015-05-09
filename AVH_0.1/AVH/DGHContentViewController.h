//
//  DGHContentViewController.h
//  DeviceGH
//
//  Created by Sreelal H on 07/12/14.
//  Copyright (c) 2014 Sreelal H. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductCategory.h"

@protocol DGHContentViewControllerDelegate <NSObject>


- (void)onGoToHomeScreen;

@end

@interface DGHContentViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout> {
    
    IBOutlet UICollectionView *categoriesCollectionView;
}

@property (weak, nonatomic) IBOutlet UILabel *contenLabel;
@property (strong, nonatomic) NSString *contentValue;
@property (assign, nonatomic) id <DGHContentViewControllerDelegate> delegate;

@property (strong, nonatomic) ProductCategory *category;

@property (strong, nonatomic) NSString *categoryID;

@end
