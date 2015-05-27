//
//  AVHBookingViewController.m
//  AVH
//
//  Created by Sreelal H on 24/05/15.
//  Copyright (c) 2015 Sreelal H. All rights reserved.
//


#import "AVHBookingViewController.h"
#import "SwipeView.h"
#import "AVHYourStayView.h"
#import "AVHEnhanceStay.h"
#import "AVHGuestDetails.h"
#import "AVHReviewView.h"
#import "AVHConfirmationView.h"
#import "HelperClass.h"

@interface AVHBookingViewController ()/*<SwipeViewDataSource, SwipeViewDelegate>*/

@property (nonatomic, weak) IBOutlet SwipeView *swipeView;

@property (nonatomic, strong) NSMutableArray *bookingViews;

@end

@implementation AVHBookingViewController


/*- (void)awakeFromNib {
    
    [self prepareViews];
}*/

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
    
    [HelperClass getCurrentDateWithFormat:@"dd/MM/yyyy"];
    
    [self prepareViews];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    _swipeView.itemsPerPage = 1;
    _swipeView.truncateFinalPage = YES;
    _swipeView.scrollEnabled = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareViews {
    
    self.bookingViews = [NSMutableArray array];
    [_bookingViews addObject:@"AVHYourStayView"];
    [_bookingViews addObject:@"AVHRoomsRatesView"];
    [_bookingViews addObject:@"AVHEnhanceStay"];
    [_bookingViews addObject:@"AVHGuestDetails"];
    [_bookingViews addObject:@"AVHReviewView"];
    [_bookingViews addObject:@"AVHConfirmationView"];
}

#pragma mark - Button Actions

- (void)navgationBackClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)navgationNextClicked:(id)sender {
    
    //[_swipeView scrollToPage:1 duration:0.5];
}

#pragma mark -ß
#pragma mark iCarousel methods

- (NSInteger)numberOfItemsInSwipeView:(SwipeView *)swipeView {
    
    //return the total number of items in the carousel
    return [_bookingViews count];
}

- (UIView *)swipeView:(SwipeView *)swipeView viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view {
   
    view = [[[NSBundle mainBundle] loadNibNamed:_bookingViews[index]
                                            owner:self
                                           options:nil]
                                        objectAtIndex:0];
    
    view.frame = CGRectMake(0, 0, swipeView.frame.size.width, swipeView.frame.size.height);
    
    return view;
}


/*- (CGSize)swipeViewItemSize:(SwipeView *)swipeView
{
 
    return self.swipeView.bounds.size;
    //return [UIScreen mainScreen].bounds.size;
}*/


@end
