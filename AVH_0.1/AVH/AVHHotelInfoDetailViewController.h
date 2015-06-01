//
//  AVHHotelInfoDetailViewController.h
//  AVH
//
//  Created by Sreelash S on 30/05/15.
//  Copyright (c) 2015 Sreelal H. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HelperClass.h"
#import "SwipeView.h"
#import "WebHandler.h"
#import "AppDelegate.h"
#import "AVHImageContainer.h"

@interface AVHHotelInfoDetailViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *detailTitle;
@property (weak, nonatomic) IBOutlet UILabel *imageCountLbl;

@property (nonatomic, strong) NSDictionary *hotelDetails;

@end
