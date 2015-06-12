//
//  CGHFaceBookViewController.h
//  CompuGhana
//
//  Created by Sreelal H on 11/02/15.
//  Copyright (c) 2015 Sreelal H. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RESideMenu.h"

@interface AVHFaceBookViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIWebView *webContent;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityView;
@property (strong, nonatomic) IBOutlet UIButton *fbLoginButton;

@property (strong, nonatomic) IBOutlet UIImageView *fbBannerImage;
@property (strong, nonatomic) IBOutlet UIImageView *fbPageImage;
@property (strong, nonatomic) IBOutlet UILabel *talksLabel;
@property (strong, nonatomic) IBOutlet UILabel *likesLabel;

@property (nonatomic, assign) BOOL isFromMenu;

@end
