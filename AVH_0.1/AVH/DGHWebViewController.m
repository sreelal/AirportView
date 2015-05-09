//
//  DGHWebViewController.m
//  DeviceGH
//
//  Created by Sreelash S on 27/01/15.
//  Copyright (c) 2015 Sreelal H. All rights reserved.
//

#import "DGHWebViewController.h"
#import "HelperClass.h"
#import "RESideMenu.h"
#import "Constants.h"

@interface DGHWebViewController ()

@end

@implementation DGHWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = self.viewTitle;

    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:[HelperClass getRightBarButtonItemTextAttributes] forState:UIControlStateNormal];
    
    [self loadWebContent];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Helper Methods

- (void)loadWebContent {
    
    NSString *strURL;
    if ([self.viewTitle isEqualToString:VIEW_TITLE_ABOUT]) {
        strURL = @"http://www.devicegh.com/index.php?route=service/content&content=4";
    }
    else if ([self.viewTitle isEqualToString:VIEW_TITLE_WEEKLY]) {
        strURL = @"http://www.devicegh.com/index.php?route=service/content&content=7";
    }
    else if ([self.viewTitle isEqualToString:VIEW_TITLE_MONTHLY]) {
        strURL = @"http://www.devicegh.com/index.php?route=service/content&content=8";
    }
    
    NSURL *url = [NSURL URLWithString:strURL];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    
    [webView loadRequest:urlRequest];
}

#pragma mark - Button Actions

- (IBAction)equireListClicked:(id)sender {
    
    UINavigationController *enquireVCNav = [self.storyboard instantiateViewControllerWithIdentifier:@"EnquireViewNavigation"];
    
    [self.sideMenuViewController setContentViewController:enquireVCNav];
    [self.sideMenuViewController hideMenuViewController];
}
@end
