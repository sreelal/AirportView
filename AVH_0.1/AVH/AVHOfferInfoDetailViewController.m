//
//  AVHHotelInfoDetailViewController.m
//  AVH
//
//  Created by Sreelash S on 30/05/15.
//  Copyright (c) 2015 Sreelal H. All rights reserved.
//

#import "AVHOfferInfoDetailViewController.h"



@interface AVHOfferInfoDetailViewController ()

@property (weak, nonatomic) IBOutlet SwipeView *swipeImageView;
@property (strong, nonatomic)NSDictionary *hotelInfoDictionary;

@property (weak, nonatomic) IBOutlet UIWebView *descriptionWebView;

@end

@implementation AVHOfferInfoDetailViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"AVH_logo.png"]];
    
    UIBarButtonItem *leftBarItem = [HelperClass getBackButtonItemWithTarget:self andAction:@selector(navgationBackClicked:)];
    leftBarItem.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = leftBarItem;
    
    _imageCountLbl.text = @"";
    
    _detailTitle.text = _offerDetails[@"title"];
    [_descriptionWebView loadHTMLString:_offerDetails[@"description"] baseURL:nil];
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
    
    //return (_offerDetails)?[[_offerDetails objectForKey:@"images"] count]:0;
    return 1;
}

- (UIView *)swipeView:(SwipeView *)swipeView viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view{
    
    AVHImageContainer *imageView = [[AVHImageContainer alloc]initWithFrame:_swipeImageView.bounds];
    
    NSString *imageURL = [NSString stringWithFormat:@"%@img/%@", SERVICE_URL_ROOT, _offerDetails[@"image"]];
    [imageView loadRoomImageWithURL:imageURL];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    //_imageCountLbl.text = [NSString stringWithFormat:@"%lu of %lu  ",index+1,[[_offerDetails objectForKey:@"images"] count]];
    
    return imageView;
}

@end
