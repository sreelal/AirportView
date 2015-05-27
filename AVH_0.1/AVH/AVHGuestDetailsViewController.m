//
//  GuestDetailsViewController.m
//  AVH
//
//  Created by Anamika on 5/27/15.
//  Copyright (c) 2015 Sreelal H. All rights reserved.
//

#import "AVHGuestDetailsViewController.h"
#import "HelperClass.h"

@interface AVHGuestDetailsViewController ()

@end

@implementation AVHGuestDetailsViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"AVH_logo.png"]];
    
    UIBarButtonItem *leftBarItem = [HelperClass getBackButtonItemWithTarget:self andAction:@selector(navgationBackClicked:)];
    leftBarItem.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = leftBarItem;
    
    UIBarButtonItem *rightBarItem = [HelperClass getNextButtonItemWithTarget:self andAction:@selector(navgationNextClicked:)];
    rightBarItem.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = rightBarItem;
    
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Button Actions

- (void)navgationBackClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)navgationNextClicked:(id)sender {
    
    //[_swipeView scrollToPage:1 duration:0.5];
}

@end
