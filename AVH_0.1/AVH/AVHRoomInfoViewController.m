//
//  AVHRoomInfoViewController.m
//  AVH
//
//  Created by Anamika on 5/26/15.
//  Copyright (c) 2015 Sreelal H. All rights reserved.
//

#import "AVHRoomInfoViewController.h"
#import "HelperClass.h"
#import "SwipeView.h"
#import "WebHandler.h"
#import "AppDelegate.h"
#import "AVHImageContainer.h"
#import "AVHGuestDetailsViewController.h"

@interface AVHRoomInfoViewController ()<SwipeViewDataSource,SwipeViewDelegate>

@property (nonatomic, strong) AVHGuestDetailsViewController *guestDetailsVC;
@property (weak, nonatomic) IBOutlet UILabel *imageCountLbl;
@property (weak, nonatomic) IBOutlet SwipeView *swipeImageView;
@property (strong, nonatomic)NSDictionary *hotelInfoDictionary;
@property (weak, nonatomic) IBOutlet UILabel *roomCostLbl;
@property (weak, nonatomic) IBOutlet UIButton *prevButton;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;

@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;
@property (weak, nonatomic) IBOutlet UILabel *roomTypeLabel;
@end

@implementation AVHRoomInfoViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"AVH_logo.png"]];
    
    UIBarButtonItem *leftBarItem = [HelperClass getBackButtonItemWithTarget:self andAction:@selector(navgationBackClicked:)];
    leftBarItem.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = leftBarItem;
    _imageCountLbl.text = @"";
    
    _prevButton.hidden = YES;

    
    //Now Load the details
    NSArray *hotelsList = _hotelDetails[@"packages"];
    [self loadHotelInfoForID:[hotelsList objectAtIndex:_selectedIndex][@"id"]];
}

- (void)loadHotelInfoForID:(NSString*)hotelID{
    
    //Loading HotelDetails for htolID
    [[AppDelegate instance] showBusyView:@"Loading Details..."];

    [WebHandler getHotelInfoForID:hotelID withCallBack:^(id object, NSError *error) {
        
        if (object) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                _hotelInfoDictionary = (NSDictionary*)object;
                //Now start Update UI
                _roomTypeLabel.text=[_hotelInfoDictionary[@"package"] objectForKey:@"name"];
                _descriptionTextView.text = [_hotelInfoDictionary[@"package"] objectForKey:@"description"];
                _roomCostLbl.text = [NSString stringWithFormat:@"$ %@",[_hotelInfoDictionary[@"package"] objectForKey:@"cost_per_day"]];
                
                [_swipeImageView reloadData];
                //Update Swipe View
                [[AppDelegate instance] hideBusyView];
                
                if (_selectedIndex==0) {
                    
                    _prevButton.hidden = YES;

                }
                if (_selectedIndex == [_hotelDetails[@"packages"] count]-1) {
                    _nextBtn.hidden = YES;
                }
            });
        }
    }];
}

#pragma mark - Swipe view delegates

- (NSInteger)numberOfItemsInSwipeView:(SwipeView *)swipeView{
    
    return (_hotelInfoDictionary)?[[_hotelInfoDictionary[@"package"] objectForKey:@"images"] count]:0;
}

- (UIView *)swipeView:(SwipeView *)swipeView viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view{
    
    AVHImageContainer *imageView = [[AVHImageContainer alloc]initWithFrame:_swipeImageView.bounds];
    [imageView loadRoomImageWithURL:[[_hotelInfoDictionary[@"package"] objectForKey:@"images"] objectAtIndex:index]];
    
    _imageCountLbl.text = [NSString stringWithFormat:@"%lu of %lu  ",index+1,[[_hotelInfoDictionary[@"package"] objectForKey:@"images"] count]];

    return imageView;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Button Actions

- (void)navgationBackClicked:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)onPreviousSelection:(id)sender {
    
    _nextBtn.hidden = NO;
    _prevButton.hidden = NO;
    NSArray *hotelsList = _hotelDetails[@"packages"];
    _selectedIndex--;
    if (_selectedIndex>=0) {
        
        [self loadHotelInfoForID:[hotelsList objectAtIndex:_selectedIndex][@"id"]];
    }
    else{
        _prevButton.hidden = YES;
    }
    
    
}
- (IBAction)onNextSelection:(id)sender {
    
    _nextBtn.hidden = NO;
    _prevButton.hidden = NO;
    NSArray *hotelsList = _hotelDetails[@"packages"];
    _selectedIndex++;
    if (_selectedIndex<[hotelsList count]) {
        [self loadHotelInfoForID:[hotelsList objectAtIndex:_selectedIndex][@"id"]];
    }
    else{
        
        _nextBtn.hidden = YES;
    }
}

- (IBAction)bookNowBtnAction:(id)sender{
  
    if ((self.delegate!=nil)&&([self.delegate respondsToSelector:@selector(didSelectBookingWithDetails:)])) {
        
        NSArray *hotelsList = _hotelDetails[@"packages"];
        [self.delegate didSelectBookingWithDetails:[hotelsList objectAtIndex:_selectedIndex]];
    }
    
}

@end
