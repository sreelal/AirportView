//
//  AVHHotelInfoDetailViewController.m
//  AVH
//
//  Created by Sreelash S on 30/05/15.
//  Copyright (c) 2015 Sreelal H. All rights reserved.
//

#import "AVHHotelInfoDetailViewController.h"



@interface AVHHotelInfoDetailViewController ()

@property (weak, nonatomic) IBOutlet SwipeView *swipeImageView;
@property (strong, nonatomic)NSDictionary *hotelInfoDictionary;

@property (weak, nonatomic) IBOutlet UIWebView *descriptionWebView;

@end

@implementation AVHHotelInfoDetailViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"AVH_logo.png"]];
    
    UIBarButtonItem *leftBarItem = [HelperClass getBackButtonItemWithTarget:self andAction:@selector(navgationBackClicked:)];
    leftBarItem.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = leftBarItem;
    
    _imageCountLbl.text = @"";
    
    _detailTitle.text = _hotelDetails[@"title"];
    [_descriptionWebView loadHTMLString:_hotelDetails[@"description"] baseURL:nil];
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
    
    return (_hotelDetails)?[[_hotelDetails objectForKey:@"images"] count]:0;
}

- (UIView *)swipeView:(SwipeView *)swipeView viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view{
    
    AVHImageContainer *imageView = [[AVHImageContainer alloc]initWithFrame:_swipeImageView.bounds];
    [imageView loadRoomImageWithURL:[[_hotelDetails objectForKey:@"images"] objectAtIndex:index]];
    
    _imageCountLbl.text = [NSString stringWithFormat:@"%lu of %lu  ",index+1,[[_hotelDetails objectForKey:@"images"] count]];
    
    return imageView;
}

@end
