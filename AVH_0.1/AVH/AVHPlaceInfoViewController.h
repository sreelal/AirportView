//
//  AVHPlaceInfoViewController.h
//  AVH
//
//  Created by Sreelash S on 03/06/15.
//  Copyright (c) 2015 Sreelal H. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AVHPlaceInfoViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *detailTitle;
@property (weak, nonatomic) IBOutlet UILabel *imageCountLbl;
@property (nonatomic, strong) NSDictionary *placeDetails;

@end
