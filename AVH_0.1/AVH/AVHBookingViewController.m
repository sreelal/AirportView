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
#import "AVHRoomsRatesView.h"

@interface AVHBookingViewController ()<SwipeViewDataSource, SwipeViewDelegate>

@property (nonatomic, weak) IBOutlet SwipeView *swipeView;

@property (nonatomic, strong) NSMutableArray *bookingViews;

@end

@implementation AVHBookingViewController


- (void)awakeFromNib
{
    [self prepareViews];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _swipeView.pagingEnabled = YES;
    [_swipeView reloadData];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareViews{
    
    self.bookingViews = [NSMutableArray array];
    [_bookingViews addObject:@"AVHYourStayView"];
    [_bookingViews addObject:@"AVHRoomsRatesView"];
    [_bookingViews addObject:@"AVHEnhanceStay"];
    [_bookingViews addObject:@"AVHGuestDetails"];
    [_bookingViews addObject:@"AVHReviewView"];
    [_bookingViews addObject:@"AVHConfirmationView"];
}

#pragma mark -
#pragma mark iCarousel methods

- (NSInteger)numberOfItemsInSwipeView:(SwipeView *)swipeView
{
    //return the total number of items in the carousel
    return [_bookingViews count];
}

- (UIView *)swipeView:(SwipeView *)swipeView viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
   

        
    view =[[[NSBundle mainBundle] loadNibNamed:_bookingViews[index]
                                            owner:self
                                           options:nil]
                                        objectAtIndex:0];
    
 
    
    return view;
}


- (CGSize)swipeViewItemSize:(SwipeView *)swipeView
{
    return self.swipeView.bounds.size;
}


@end
