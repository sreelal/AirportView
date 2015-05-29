//
//  AVHRoomsRatesViewController.m
//  AVH
//
//  Created by Sreelal H on 25/05/15.
//  Copyright (c) 2015 Sreelal H. All rights reserved.
//

#import "AVHRoomsRatesViewController.h"
#import "WebHandler.h"
#import "AVHHotelCellTableViewCell.h"
#import "HelperClass.h"
#import "AppDelegate.h"
#import "AVHGuestDetailsViewController.h"
#import "AVHRoomInfoViewController.h"

@interface AVHRoomsRatesViewController ()<AVHRoomInfoViewControllerDelegtae>

@property (nonatomic, weak) IBOutlet UITableView *hotelsTable;
@property (nonatomic, strong) NSDictionary *hotelDetails;
@property (nonatomic, strong) AVHGuestDetailsViewController *guestDetailsVC;


@end

@implementation AVHRoomsRatesViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];

    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"AVH_logo.png"]];
    
    UIBarButtonItem *leftBarItem = [HelperClass getBackButtonItemWithTarget:self andAction:@selector(navgationBackClicked:)];
    leftBarItem.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = leftBarItem;
    
//    UIBarButtonItem *rightBarItem = [HelperClass getNextButtonItemWithTarget:self andAction:@selector(navgationNextClicked:)];
//    rightBarItem.tintColor = [UIColor whiteColor];
//    self.navigationItem.rightBarButtonItem = rightBarItem;
    
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    
    [[AppDelegate instance] showBusyView:@"Loading Rooms..."];
    
    [WebHandler getHotelsList:^(id object, NSError *error) {
        
        if (object) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                _hotelDetails = object;
                [_hotelsTable reloadData];
                
                [[AppDelegate instance] hideBusyView];
            });
      
        }
    }];
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
    
    _guestDetailsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"GuestDetailsVC"];
    
    [self.navigationController pushViewController:_guestDetailsVC animated:YES];
    
    _guestDetailsVC = nil;
    //[_swipeView scrollToPage:1 duration:0.5];
}

- (void)moreInfoBtnAction:(id)sender {
    
    UIButton *selectedButton = (UIButton*)sender;
    UINavigationController *roomInfoRootVC = [self.storyboard instantiateViewControllerWithIdentifier:@"RoomInfoNavVC"];
    AVHRoomInfoViewController *_roomInfoVC = [roomInfoRootVC.viewControllers lastObject];
    _roomInfoVC.hotelDetails = self.hotelDetails;
    _roomInfoVC.selectedIndex = selectedButton.tag;
    _roomInfoVC.delegate = self;
    [self presentViewController:roomInfoRootVC animated:YES completion:nil];
}

- (void)bookNowBtnAction:(id)sender{
    
    _guestDetailsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"GuestDetailsVC"];
    
    [self.navigationController pushViewController:_guestDetailsVC animated:YES];
    
    _guestDetailsVC = nil;

}


#pragma mark - TableView Delegates

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSArray *hotelsList = _hotelDetails[@"packages"];
    return [hotelsList count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellId = @"hotelCell";
    AVHHotelCellTableViewCell *hotelCell = (AVHHotelCellTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
    
   // hotelCell.selectionStyle = UITableViewCellSelectionStyleNone;
    hotelCell.moreInfoBtn.tag = indexPath.row;
    hotelCell.hotelBookNowBtn.tag = indexPath.row;
    
    NSArray *hotelsList = _hotelDetails[@"packages"];

    NSDictionary *hotelDetails = hotelsList[indexPath.row];
    
    hotelCell.hotelRate.text = [NSString stringWithFormat:@"%@ $",hotelDetails[@"cost_per_day"]];
    hotelCell.hotelDescription.text = hotelDetails[@"description"];
    hotelCell.hotelduration.text = hotelDetails[@"name"];
    
    [hotelCell loadRoomImageWithURL:hotelDetails[@"image"]];
    [hotelCell.moreInfoBtn addTarget:self action:@selector(moreInfoBtnAction:) forControlEvents:UIControlEventTouchUpInside];
     [hotelCell.hotelBookNowBtn addTarget:self action:@selector(bookNowBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    if (hotelCell.hotelDescription.text.length > 150) {
        hotelCell.hotelDescription.text = [NSString stringWithFormat:@"%@...", [hotelCell.hotelDescription.text substringToIndex:150]];
    }
    
    return hotelCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 210;
}

#pragma mark - AVHRoomInfoViewController Delegtae{

- (void)didSelectBookingWithDetails:(NSDictionary*)details{
    
    [self dismissViewControllerAnimated:NO completion:^{
        
        _guestDetailsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"GuestDetailsVC"];
        
        [self.navigationController pushViewController:_guestDetailsVC animated:YES];
        
        _guestDetailsVC = nil;
    }];
    
}

@end
