//
//  AVHPlaceInfoViewController.m
//  AVH
//
//  Created by Sreelash S on 03/06/15.
//  Copyright (c) 2015 Sreelal H. All rights reserved.
//

#import "AVHPlaceInfoViewController.h"
#import "SwipeView.h"
#import "HelperClass.h"
#import "AVHImageContainer.h"

@interface AVHPlaceInfoViewController ()

@property (weak, nonatomic) IBOutlet SwipeView *swipeImageView;
@property (strong, nonatomic)NSDictionary *hotelInfoDictionary;

@property (weak, nonatomic) IBOutlet UIWebView *descriptionWebView;

@end

@implementation AVHPlaceInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"AVH_logo.png"]];
    
    UIBarButtonItem *leftBarItem = [HelperClass getBackButtonItemWithTarget:self andAction:@selector(navgationBackClicked:)];
    leftBarItem.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = leftBarItem;
    
    _imageCountLbl.text = @"";
    
    _detailTitle.text = _placeDetails[@"title"];
    [_descriptionWebView loadHTMLString:_placeDetails[@"description"] baseURL:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Button Actions

- (void)navgationBackClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Swipe view delegates

- (NSInteger)numberOfItemsInSwipeView:(SwipeView *)swipeView{
    
    return (_placeDetails)?[[_placeDetails objectForKey:@"images"] count]:0;
}

- (UIView *)swipeView:(SwipeView *)swipeView viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view{
    
    AVHImageContainer *imageView = [[AVHImageContainer alloc]initWithFrame:_swipeImageView.bounds];
    [imageView loadRoomImageWithURL:[[_placeDetails objectForKey:@"images"] objectAtIndex:index]];
    
    _imageCountLbl.text = [NSString stringWithFormat:@"%lu of %lu  ",index+1,[[_placeDetails objectForKey:@"images"] count]];
    
    return imageView;
}

@end
