//
//  GuestDetailsViewController.m
//  AVH
//
//  Created by Anamika on 5/27/15.
//  Copyright (c) 2015 Sreelal H. All rights reserved.
//

#import "AVHGuestDetailsViewController.h"
#import "HelperClass.h"
#import "InputAccessoryBar.h"

@interface AVHGuestDetailsViewController () <ToolbarDelegate> {
    NSArray *titles;
    NSArray *countries;
    
    UITextField *activeTextField;
    CGFloat viewDefaultHeightPin;
}

@property (weak, nonatomic) IBOutlet UITextField *titleTxt;
@property (weak, nonatomic) IBOutlet UITextField *firstnameTxt;
@property (weak, nonatomic) IBOutlet UITextField *lastnameTxt;
@property (weak, nonatomic) IBOutlet UITextField *dobTxt;
@property (weak, nonatomic) IBOutlet UITextField *emailTxt;
@property (weak, nonatomic) IBOutlet UITextField *companynameTxt;
@property (weak, nonatomic) IBOutlet UITextField *countryTxt;
@property (weak, nonatomic) IBOutlet UITextField *cityTxt;
@property (weak, nonatomic) IBOutlet UITextField *postalcodeTxt;
@property (weak, nonatomic) IBOutlet UITextField *phoneNoTxt;
@property (weak, nonatomic) IBOutlet UITextField *comments2Txt;
@property (weak, nonatomic) IBOutlet UITextField *addressTxt;
@property (weak, nonatomic) IBOutlet UITextField *addressTxt2;
@property (weak, nonatomic) IBOutlet UITextField *addressTxt3;

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
    
    [scrollView setContentOffset:CGPointMake(0, 250) animated:YES];
    
    countries = [HelperClass getListOfCountries];
    titles    = [[NSArray alloc] initWithObjects:@"Ms.", @"Miss", @"Mrs", @"Mr.",  @"Dr.", @"Professor", nil];
    
    viewDefaultHeightPin = pinHeightConstraint.constant;
    
    txtPostalCode.inputAccessoryView  = [self getInputAccesory];
    txtPhoneNumber.inputAccessoryView = [self getInputAccesory];
    
    NSLog(@"Pin Constraints : %lf", scrollView.frame.size.height);
    //NSLog(@"Pin Constraints : %lf", pinHeightConstraint.constant);
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
    
}

- (IBAction)showDatePicker:(id)sender {
    
    if (activeTextField)
        [activeTextField resignFirstResponder];
    
    UIButton *btn     = (UIButton *)sender;
    
    pickerComponent = [[PickerComponent alloc] initWithFrame:[UIScreen mainScreen].bounds forSelectedDate:[NSDate date] andDelegate:self withTag:btn.tag];
}

- (IBAction)showPicker:(id)sender {
    
    if (activeTextField)
        [activeTextField resignFirstResponder];
    
    UIButton *btn     = (UIButton *)sender;
    NSMutableArray *data;
    
    if (btn.tag == 0)
        data = (NSMutableArray *)titles;
    else
        data = (NSMutableArray *)countries;
    
    pickerComponent = [[PickerComponent alloc] initWithFrame:[UIScreen mainScreen].bounds andDelegate:self andData:data withTag:btn.tag];
}

#pragma mark - Picker Component Delegate

- (void)didPickerSelectForRowAtIndex:(int)index andTag:(int)tag {
    
    NSLog(@"Selected Index: %d", index);
    
    if (tag == 0)
        txtTitle.text = titles[index];
    else
        txtCountry.text = countries[index];
    
    pickerComponent = nil;
}

- (void)didSelectedDate:(NSDate *)date andTag:(int)tag {
    
    if (activeTextField)
        [activeTextField resignFirstResponder];
    
    NSLog(@"Date Selected: %@", [HelperClass getStringDateFromNSDate:date withFormat:DATE_FORMAT_MM_DD_YYYY]);
    
    txtDob.text = [HelperClass getStringDateFromNSDate:date withFormat:DATE_FORMAT_MM_DD_YYYY];
    
    pickerComponent = nil;
}

- (void)didPickerCancel {
    
    NSLog(@"Picker Cancelled");
    
    pickerComponent = nil;
}

#pragma mark - TextField Delegate

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    activeTextField = textField;
    
    pinHeightConstraint.constant = viewDefaultHeightPin + 250;
    
    [self.view layoutIfNeeded];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    activeTextField = nil;
    
    pinHeightConstraint.constant = viewDefaultHeightPin;
    
    [self.view layoutIfNeeded];
    
    [textField resignFirstResponder];
    
    return YES;
}

#pragma mark - Helper Methods

- (InputAccessoryBar *)getInputAccesory {
    
    InputAccessoryBar *inputAccessoryBar = [[NSBundle mainBundle] loadNibNamed:@"InputAccessoryBar" owner:self options:nil][0];
    inputAccessoryBar.delegate = self;
    inputAccessoryBar.frame = CGRectMake(inputAccessoryBar.frame.origin.x, inputAccessoryBar.frame.origin.y, [UIScreen mainScreen].bounds.size.width, inputAccessoryBar.frame.size.height);
    
    return inputAccessoryBar;
}

#pragma mark - Toolbar delegate

- (void)toolBarDoneAction {
    
    [activeTextField resignFirstResponder];
    
    //[self sendEnquiryAction:nil];
    
    activeTextField = nil;
    
    pinHeightConstraint.constant = viewDefaultHeightPin;
    
    [self.view layoutIfNeeded];
}

- (void)toolBarCancelAction {
    
    [activeTextField resignFirstResponder];
    
    activeTextField = nil;
    
    pinHeightConstraint.constant = viewDefaultHeightPin;
    
    [self.view layoutIfNeeded];
}


- (void)loadSavedInformation{
    
    NSMutableDictionary *_guestInfoDictionary = [self retrieveInformations];
    if (_guestInfoDictionary) {
        
        _titleTxt.text = [_guestInfoDictionary objectForKey:@"titleTxt"];
        _firstnameTxt.text = [_guestInfoDictionary objectForKey:@"firstname"];
        _lastnameTxt.text = [_guestInfoDictionary objectForKey:@"lastname"];
        _dobTxt.text = [_guestInfoDictionary objectForKey:@"dob"];
        _emailTxt.text = [_guestInfoDictionary objectForKey:@"email"];
        
        _companynameTxt.text = [_guestInfoDictionary objectForKey:@"companyname"];
        _countryTxt.text = [_guestInfoDictionary objectForKey:@"country"];
        _addressTxt.text = [_guestInfoDictionary objectForKey:@"address1"];
        _addressTxt2.text = [_guestInfoDictionary objectForKey:@"address2"];
        _addressTxt3.text = [_guestInfoDictionary objectForKey:@"address3"];
        
        _cityTxt.text = [_guestInfoDictionary objectForKey:@"city"];
        _postalcodeTxt.text = [_guestInfoDictionary objectForKey:@"postalcode"];
        _phoneNoTxt.text = [_guestInfoDictionary objectForKey:@"phoneno"];
        
    }
}

- (void)saveInformations{
    
    //YOUR_STAY_INFO
    NSMutableDictionary *_guestInfoDictionary = [NSMutableDictionary dictionary];
    [_guestInfoDictionary setObject:(_titleTxt.text)?_titleTxt.text:@"" forKey:@"titleTxt"];
    [_guestInfoDictionary setObject:(_firstnameTxt.text)?_firstnameTxt.text:@"" forKey:@"firstname"];
    [_guestInfoDictionary setObject:(_lastnameTxt.text)?_lastnameTxt.text:@"" forKey:@"lastname"];
    [_guestInfoDictionary setObject:(_dobTxt.text)?_dobTxt.text:@"" forKey:@"dob"];
    [_guestInfoDictionary setObject:(_emailTxt.text)?_emailTxt.text:@"" forKey:@"email"];
    
    [_guestInfoDictionary setObject:(_companynameTxt.text)?_companynameTxt.text:@"" forKey:@"companyname"];
    [_guestInfoDictionary setObject:(_countryTxt.text)?_countryTxt.text:@"" forKey:@"country"];
    [_guestInfoDictionary setObject:(_addressTxt.text)?_addressTxt.text:@"" forKey:@"address1"];
    [_guestInfoDictionary setObject:(_addressTxt2.text)?_addressTxt2.text:@"" forKey:@"address2"];
    [_guestInfoDictionary setObject:(_addressTxt3.text)?_addressTxt3.text:@"" forKey:@"address3"];
    
    [_guestInfoDictionary setObject:(_cityTxt.text)?_cityTxt.text:@"" forKey:@"city"];
    [_guestInfoDictionary setObject:(_postalcodeTxt.text)?_postalcodeTxt.text:@"" forKey:@"postalcode"];
    [_guestInfoDictionary setObject:(_phoneNoTxt.text)?_phoneNoTxt.text:@"" forKey:@"phoneno"];
    
    
    if (![[AVHDataHandler sharedManager] bookingDataHolder]) {
        
        [[AVHDataHandler sharedManager] setBookingDataHolder:[NSMutableDictionary dictionary]];
    }
    [[[AVHDataHandler sharedManager] bookingDataHolder] setObject:_guestInfoDictionary forKey:GUEST_DETAILS];
    
}

- (NSMutableDictionary*)retrieveInformations{
    
    return [[[AVHDataHandler sharedManager] bookingDataHolder] objectForKey:GUEST_DETAILS];
    ;
}

@end
