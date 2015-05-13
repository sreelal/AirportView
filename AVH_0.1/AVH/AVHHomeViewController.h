//
//  DGHHomeViewController.h
//  DeviceGH
//
//  Created by Sreelal H on 07/12/14.
//  Copyright (c) 2014 Sreelal H. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RESideMenu.h"
#import "MarqueeLabel.h"
#import "AVHWeatherViewController.h"
#import "AVHFlightInfoViewController.h"

@interface AVHHomeViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout> {    
    
    IBOutlet UICollectionView *categoiesCollectionView;
}

@property (nonatomic, strong) IBOutlet MarqueeLabel *footerLabel;

@property (nonatomic, strong) NSMutableArray *homeCategories;

@end
