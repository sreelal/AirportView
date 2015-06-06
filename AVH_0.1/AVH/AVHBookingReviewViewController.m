//
//  AVHBookingReviewViewController.m
//  AVH
//
//  Created by Sreelal  Hamsavahanan on 04/06/15.
//  Copyright (c) 2015 Sreelal H. All rights reserved.
//

#import "AVHBookingReviewViewController.h"
#import "AVHEditStayCell.h"
#import "AVHEditRoomCell.h"
#import "AVHEditGuestsCell.h"
#import "AVHDataHandler.h"
#import "Constants.h"
#import "HelperClass.h"
#import "WebHandler.h"
#import "AppDelegate.h"

@interface AVHBookingReviewViewController()

@property (weak, nonatomic) IBOutlet UITableView *reviewTable;
@end

@implementation AVHBookingReviewViewController


- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"AVH_logo.png"]];
    
    UIBarButtonItem *rightBarItem = [HelperClass getReviewAndSubmitButton:self andAction:@selector(onBookNow:)];
    rightBarItem.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = rightBarItem;
    
    [self.navigationItem setHidesBackButton:YES];
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [_reviewTable reloadData];
}

#pragma mark - TableView Delegates & Datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 3;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *_cell = nil;
    switch (indexPath.row) {
        case 0:
        {
            AVHEditStayCell *editStayCell = (AVHEditStayCell *)[tableView dequeueReusableCellWithIdentifier:@"editStayCell" forIndexPath:indexPath];

            NSMutableDictionary *_stayDetails = [[[AVHDataHandler sharedManager] bookingDataHolder] objectForKey:YOUR_STAY_INFO];
            if (_stayDetails) {
                
                editStayCell.checkinDate.text =_stayDetails[@"check_in"];
                editStayCell.checkoutDate.text =_stayDetails[@"check_out"];
                editStayCell.adultsValue.text =_stayDetails[@"adults"];
                editStayCell.childrenValue.text =_stayDetails[@"children"];
                editStayCell.roomsValue.text =_stayDetails[@"rooms"];
                editStayCell.editButton.tag = indexPath.row;
                [editStayCell.editButton addTarget:self action:@selector(onSelectEdit:) forControlEvents:UIControlEventTouchUpInside];
            }
            
            _cell = editStayCell;
        }
            break;
            
        case 1:
        {
            AVHEditRoomCell *editHotelCell = (AVHEditRoomCell *)[tableView dequeueReusableCellWithIdentifier:@"editRoomCell" forIndexPath:indexPath];
            
            NSMutableDictionary *_stayDetails = [[[AVHDataHandler sharedManager] bookingDataHolder] objectForKey:ROOM_RATES_INFO];
            if (_stayDetails) {
                
                editHotelCell.roomDescription.text =_stayDetails[@"description"];
                editHotelCell.roomPrice.text =[NSString stringWithFormat:@"%@ $",_stayDetails[@"cost_per_day"]];
                editHotelCell.titleValue.text = _stayDetails[@"name"];
                [editHotelCell loadHotelImageFrom:_stayDetails[@"image"]];
               // image
                if (editHotelCell.roomDescription.text.length > 150) {
                    editHotelCell.roomDescription.text = [NSString stringWithFormat:@"%@...", [editHotelCell.roomDescription.text substringToIndex:150]];
                }
                editHotelCell.editButton.tag = indexPath.row;
                [editHotelCell.editButton addTarget:self action:@selector(onSelectEdit:) forControlEvents:UIControlEventTouchUpInside];

                
            }
            
            _cell = editHotelCell;
           
        }
            break;
            
        case 2:
        {
            
            AVHEditGuestsCell *editGuestCell = (AVHEditGuestsCell *)[tableView dequeueReusableCellWithIdentifier:@"editGuestCell" forIndexPath:indexPath];
            
            NSMutableDictionary *_guestDetails = [[[AVHDataHandler sharedManager] bookingDataHolder] objectForKey:GUEST_DETAILS];
            if (_guestDetails) {
                
                editGuestCell.titleValue.text =_guestDetails[@"titleTxt"];
                editGuestCell.firstnameValue.text =_guestDetails[@"firstname"];
                editGuestCell.lastnameValue.text = _guestDetails[@"lastname"];
                editGuestCell.dobValue.text = _guestDetails[@"dob"];
                editGuestCell.emailValue.text = _guestDetails[@"email"];
                editGuestCell.companyNameValue.text = _guestDetails[@"companyname"];
                editGuestCell.countryValue.text = _guestDetails[@"country"];
                editGuestCell.cityValue.text = _guestDetails[@"city"];
                editGuestCell.postalcodeValue.text = _guestDetails[@"postalcode"];
                editGuestCell.phoneValue.text = _guestDetails[@"phoneno"];
                editGuestCell.addressValue.text = _guestDetails[@"address1"];
                editGuestCell.editButton.tag = indexPath.row;
                [editGuestCell.editButton addTarget:self action:@selector(onSelectEdit:) forControlEvents:UIControlEventTouchUpInside];

            }
            
            _cell = editGuestCell;
        }
            break;
            
        default:
            break;
    }
    
    return _cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CGFloat rowHeight = 50.0f;
    switch (indexPath.row) {
        case 0:
        {
            rowHeight = 80.0f;
        }
            break;
        case 1:
        {
            
            rowHeight = 200.0f;

        }
            break;
        case 2:
        {
            rowHeight = 335.0f;
        }
            break;
            
        default:
            break;
    }
    return rowHeight;
}

#pragma mark - Button actions


- (void)onBookNow:(id)sender{
    
    //
    //Post all the data
    [[AppDelegate instance] showBusyView:@"Booking Rooms..."];
    //Prepare request now
    
    NSMutableDictionary *_bookingDictionary = [NSMutableDictionary dictionary];
    
    NSMutableDictionary *_stayInformations = [[[AVHDataHandler sharedManager] bookingDataHolder] objectForKey:YOUR_STAY_INFO];
    NSMutableDictionary *_roomRatesInfo = [[[AVHDataHandler sharedManager] bookingDataHolder] objectForKey:ROOM_RATES_INFO];
    NSMutableDictionary *_guestDetails = [[[AVHDataHandler sharedManager] bookingDataHolder] objectForKey:GUEST_DETAILS];
    

    _bookingDictionary[@"check_in"] = (_stayInformations[@"check_in"])?_stayInformations[@"check_in"]:@"";
    _bookingDictionary[@"check_out"] =(_stayInformations[@"check_out"])?_stayInformations[@"check_out"]:@"";
    _bookingDictionary[@"adults"] = (_stayInformations[@"adults"])?_stayInformations[@"adults"]:@"";
    _bookingDictionary[@"children"] = (_stayInformations[@"children"])?_stayInformations[@"children"]:@"";
    _bookingDictionary[@"rooms"] = (_stayInformations[@"rooms"])?_stayInformations[@"rooms"]:@"";
    _bookingDictionary[@"package_id"] = (_roomRatesInfo[@"id"])?_roomRatesInfo[@"id"]:@"";
    _bookingDictionary[@"title"] = (_guestDetails[@"titleTxt"])?_guestDetails[@"titleTxt"]:@"";

    _bookingDictionary[@"first_name"] = (_guestDetails[@"firstname"])?_guestDetails[@"firstname"]:@"";
    _bookingDictionary[@"last_name"] = (_guestDetails[@"lastname"])?_guestDetails[@"lastname"]:@"";
    _bookingDictionary[@"date_of_birth"] = (_guestDetails[@"dob"])?_guestDetails[@"dob"]:@"";
    _bookingDictionary[@"email"] = (_guestDetails[@"email"])?_guestDetails[@"email"]:@"";
    _bookingDictionary[@"company"] = (_guestDetails[@"companyname"])?_guestDetails[@"companyname"]:@"";
    _bookingDictionary[@"country"] = (_guestDetails[@"country"])?_guestDetails[@"country"]:@"";
    _bookingDictionary[@"address1"] = (_guestDetails[@"address1"])?_guestDetails[@"address1"]:@"";
    _bookingDictionary[@"address2"] =@"";
    _bookingDictionary[@"address3"] = @"";
    _bookingDictionary[@"city"] = (_guestDetails[@"city"])?_guestDetails[@"city"]:@"";
    _bookingDictionary[@"postal_code"] = (_guestDetails[@"postalcode"])?_guestDetails[@"postalcode"]:@"";
    _bookingDictionary[@"day_phone"] = (_guestDetails[@"phoneno"])?_guestDetails[@"phoneno"]:@"";
    _bookingDictionary[@"mobile_phone"] = (_guestDetails[@"phoneno"])?_guestDetails[@"phoneno"]:@"";
    _bookingDictionary[@"comments"] = (_guestDetails[@"comments"])?_guestDetails[@"comments"]:@"";

    
    [WebHandler bookRoomNowWithDetails:_bookingDictionary andResponseCallback:^(id object, NSError *error) {
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [[AppDelegate instance] hideBusyView];
            
            if (!error) {
                
                NSDictionary *_bbokingResponse = (NSDictionary*)object;
                if ([_bbokingResponse[@"errors"] count]<=0) {
                    
                    
                    UIAlertView *_alert = [[UIAlertView alloc] initWithTitle:@""
                                                                     message:[NSString stringWithFormat:@"Your Room has been booked"]
                                                                    delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                    [_alert show];
                }
                else{
                    
                    UIAlertView *_alert = [[UIAlertView alloc] initWithTitle:@""
                                                                     message:[NSString stringWithFormat:@"Error Occured while booking .Please check all the data and try again"]
                                                                    delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                    [_alert show];
                }
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

- (void)onSelectEdit:(id)sender{
    
    UIButton *selectedButton = (UIButton*)sender;
    UINavigationController *selectedViewController = nil;
    
    switch (selectedButton.tag) {
        case 0:
        {
            
            selectedViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"yourstayNavigaton"];
        }
            break;
            
        case 1:
        {
            
             selectedViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"roomRatesNavigationVC"];
        }
            break;
            
        case 2:
        {
            selectedViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"guestDetailsNavigationVC"];
        }
            break;

        default:
            break;
    }
    
    UIViewController *_contentViewcontroller = selectedViewController.viewControllers.firstObject;
 
    [self presentViewController:selectedViewController
                       animated:YES
                     completion:^{
                         
                         if ([_contentViewcontroller conformsToProtocol:@protocol(AVHBookingProtocol)]) {
                             
                             [(id<AVHBookingProtocol>)_contentViewcontroller enableEditMode];
                         }
                         
                     }];
}

#pragma mark - UIAlert delegates

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    [self.navigationController popToRootViewControllerAnimated:NO];
}

@end
