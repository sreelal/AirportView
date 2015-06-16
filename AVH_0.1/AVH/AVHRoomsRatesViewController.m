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
#import "AVHDataHandler.h"

@interface AVHRoomsRatesViewController ()<AVHRoomInfoViewControllerDelegtae,AVHBookingProtocol>

@property (nonatomic, weak) IBOutlet UITableView *hotelsTable;
@property (nonatomic, strong) NSDictionary *hotelDetails;
@property (nonatomic, strong) AVHGuestDetailsViewController *guestDetailsVC;
@property (nonatomic, strong) NSDictionary *selectedHotelDetails;
@property (nonatomic, assign) BOOL isEditMode;


@end

@implementation AVHRoomsRatesViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];

    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"AVH_logo.png"]];
    
    UIBarButtonItem *leftBarItem = [HelperClass getBackButtonItemWithTarget:self andAction:@selector(navgationBackClicked:)];
    leftBarItem.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = leftBarItem;
    
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    [[AppDelegate instance] showBusyView:@"Loading Rooms..."];
    [WebHandler getHotelsList:^(id object, NSError *error) {
        
    dispatch_async(dispatch_get_main_queue(), ^{
        [[AppDelegate instance] hideBusyView];
        if (object) {
            
            _hotelDetails = object;
            [_hotelsTable reloadData];
            
        }
        else{
            
            UIAlertView *_alert = [[UIAlertView alloc] initWithTitle:@""
                                                             message:[NSString stringWithFormat:@"Unexpected error occured.Please try again later"]
                                                            delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [_alert show];
        }
        
       });

    }];
}


- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [self loadSavedInformation];
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
    
    UIButton *btnSelected = (UIButton*)sender;
    NSArray *hotelsList = _hotelDetails[@"packages"];
    self.selectedHotelDetails = [hotelsList objectAtIndex:btnSelected.tag];
    [self saveInformations];
    
    if (_isEditMode) {
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else {
        
        _guestDetailsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"GuestDetailsVC"];
        [self.navigationController pushViewController:_guestDetailsVC animated:YES];
        _guestDetailsVC = nil;
    }
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
    
    if (self.selectedHotelDetails) {
        
        if ([self.selectedHotelDetails[@"name"] isEqualToString:hotelDetails[@"name"]]) {
            
            [hotelCell.hotelBookNowBtn setUserInteractionEnabled:NO];
            [hotelCell.hotelBookNowBtn setTitle:@"" forState:UIControlStateNormal];
            [hotelCell.hotelBookNowBtn setImage:[UIImage imageNamed:@"tick"] forState:UIControlStateNormal];
        }
        else {
            [hotelCell.hotelBookNowBtn setUserInteractionEnabled:YES];
            [hotelCell.hotelBookNowBtn setImage:[UIImage imageNamed:@"AVH_Book"] forState:UIControlStateNormal];
        }
    }
    
    return hotelCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 210;
}

#pragma mark - AVHRoomInfoViewController Delegtae{

- (void)didSelectBookingWithDetails:(NSDictionary*)details{
    
    [self dismissViewControllerAnimated:NO completion:^{
        
        self.selectedHotelDetails = details;
        [self saveInformations];
        _guestDetailsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"GuestDetailsVC"];
        [self.navigationController pushViewController:_guestDetailsVC animated:YES];
        _guestDetailsVC = nil;
    }];
    
}

- (void)loadSavedInformation{
    
    NSMutableDictionary *_stayInfoDictionary = [self retrieveInformations];
    self.selectedHotelDetails = _stayInfoDictionary;
    [_hotelsTable reloadData];
}

#pragma mark - Protocol methods

- (void)saveInformations{
    
    if (![[AVHDataHandler sharedManager] bookingDataHolder]) {
        
        [[AVHDataHandler sharedManager] setBookingDataHolder:[NSMutableDictionary dictionary]];
    }
    [[[AVHDataHandler sharedManager] bookingDataHolder] setObject:self.selectedHotelDetails forKey:ROOM_RATES_INFO];
    NSLog(@"done");
}

- (NSMutableDictionary*)retrieveInformations{
    
    return [[[AVHDataHandler sharedManager] bookingDataHolder] objectForKey:ROOM_RATES_INFO];
    ;
}

- (void)enableEditMode{
    
    UIBarButtonItem *rightBarItem = [HelperClass getUpdateButton:self andAction:@selector(onUpdateData)];
    rightBarItem.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = rightBarItem;
    
    [self.navigationItem setHidesBackButton:YES];
    self.navigationItem.leftBarButtonItem = nil;
    _isEditMode = YES;
}

- (void)onUpdateData{
    
    [self saveInformations];
    //navigate back to review page
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
