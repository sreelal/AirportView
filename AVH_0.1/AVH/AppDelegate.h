//
//  AppDelegate.h
//  DeviceGH
//
//  Created by Sreelal H on 07/12/14.
//  Copyright (c) 2014 Sreelal H. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AVHMBProgressHUD.h"
#import "AVHHomeViewController.h"
#import "DGHContentViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (retain) AVHMBProgressHUD *hud;

@property (strong, nonatomic) AVHHomeViewController *homeVC;

+ (AppDelegate *)instance;

- (void)hideBusyView;

- (void)showBusyView:(NSString *)textToDisplay;

@end

