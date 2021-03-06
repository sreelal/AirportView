//
//  GuestDetailsViewController.m
//  AVH
//
//  Created by Anamika on 5/27/15.
//  Copyright (c) 2015 Sreelal H. All rights reserved.
//

#import "AVHGuestDetailsViewController.h"
#import "HelperClass.h"
#import "AVHDataHandler.h"
#import "InputAccessoryBar.h"

@interface AVHGuestDetailsViewController () <ToolbarDelegate,AVHBookingProtocol> {
    NSArray *titles;
    NSArray *countries;
    
    UITextField *activeTextField;
    CGFloat viewDefaultHeightPin;
}

/*@property (weak, nonatomic) IBOutlet UITextField *titleTxt;
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
@property (weak, nonatomic) IBOutlet UITextField *addressTxt3;*/

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
    
    //[scrollView setContentOffset:CGPointMake(0, 250) animated:YES];
    
    countries = [HelperClass getListOfCountries];
    titles    = [[NSArray alloc] initWithObjects:@"Ms.", @"Miss", @"Mrs", @"Mr.",  @"Dr.", @"Professor", nil];
    
    viewDefaultHeightPin = pinHeightConstraint.constant;
    
    txtPostalCode.inputAccessoryView  = [self getInputAccesory];
    txtPhoneNumber.inputAccessoryView = [self getInputAccesory];
    txtComments.inputAccessoryView = [self getInputAccesory];
    txtComments.layer.cornerRadius = 5.0f;
    txtComments.layer.borderWidth = 0.5f;
    txtComments.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    
    NSLog(@"Pin Constraints : %lf", scrollView.frame.size.height);
    
    //Testing
    
    //CGPoint point = CGPointMake(0.0f, -100);
    //scrollView.contentOffset = point;
    
    //[txtAddress becomeFirstResponder];
    
    //[self autoScrolTextField:txtAddress];
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [self loadSavedInformation];
}

- (void)viewDidLayoutSubviews {
    
    NSLog(@"Content Size: %f", scrollView.contentSize.height);
    
    //scrollView.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, 1200);
    
    //NSLog(@"Content Size: %f", scrollView.contentSize.height);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)validateEmailWithString:(NSString*)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

- (BOOL)validateFields{
    
    
    if ((txtTitle.text.length<=0)||
        (txtFirstName.text.length<=0)||
        (txtLastName.text.length<=0)||
        (txtDob.text.length<=0)||
        (txtEmail.text.length<=0)||
        (txtAddress.text.length<=0)||
        (txtCity.text.length<=0)||
        (txtPhoneNumber.text.length<=0)||
        (txtCountry.text.length<=0)) {
        
        return NO;
    }
    return YES;
}

#pragma mark - Button Actions

- (void)navgationBackClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)navgationNextClicked:(id)sender {
    
    if ([self validateFields]) {
        
        if ([self validateEmailWithString:txtEmail.text]) {
            
            [self saveInformations];
            [self.navigationController pushViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"bookingReviewVC"] animated:YES];
            
        }
        else{
            
            UIAlertView *_alert = [[UIAlertView alloc] initWithTitle:@""
                                                             message:[NSString stringWithFormat:@"Please enter a valid email"]
                                                            delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [_alert show];
            return;
            
        }
    }
    else{
        
        UIAlertView *_alert = [[UIAlertView alloc] initWithTitle:@""
                                                         message:[NSString stringWithFormat:@"Please enter all the informations"]
                                                        delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [_alert show];
        return;
    }
    
 
    
}

- (IBAction)showDatePicker:(id)sender {
    
    if (activeTextField)
        [activeTextField resignFirstResponder];
    
    UIButton *btn     = (UIButton *)sender;
    
    pickerComponent = [[PickerComponent alloc] initWithFrame:[UIScreen mainScreen].bounds forSelectedDate:[NSDate date] andMinDate:nil  andDelegate:self withTag:btn.tag];
}

- (void)loadSavedInformation {
    
    NSMutableDictionary *_guestInfoDictionary = [self retrieveInformations];
    
    if (_guestInfoDictionary) {
        
        txtTitle.text = [_guestInfoDictionary objectForKey:@"titleTxt"];
        txtFirstName.text = [_guestInfoDictionary objectForKey:@"firstname"];
        txtLastName.text = [_guestInfoDictionary objectForKey:@"lastname"];
        txtDob.text = [_guestInfoDictionary objectForKey:@"dob"];
        txtEmail.text = [_guestInfoDictionary objectForKey:@"email"];
        
        txtCompanyName.text = [_guestInfoDictionary objectForKey:@"companyname"];
        txtCountry.text = [_guestInfoDictionary objectForKey:@"country"];
        txtAddress.text = [_guestInfoDictionary objectForKey:@"address1"];
        
        txtCity.text = [_guestInfoDictionary objectForKey:@"city"];
        txtPostalCode.text = [_guestInfoDictionary objectForKey:@"postalcode"];
        txtPhoneNumber.text = [_guestInfoDictionary objectForKey:@"phoneno"];
    }
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

#pragma mark - Protocol methods

- (void)saveInformations {
    
    //YOUR_STAY_INFO
    NSMutableDictionary *_guestInfoDictionary = [NSMutableDictionary dictionary];
    [_guestInfoDictionary setObject:(txtTitle.text)?txtTitle.text:@"" forKey:@"titleTxt"];
    [_guestInfoDictionary setObject:(txtFirstName.text)?txtFirstName.text:@"" forKey:@"firstname"];
    [_guestInfoDictionary setObject:(txtLastName.text)?txtLastName.text:@"" forKey:@"lastname"];
    [_guestInfoDictionary setObject:(txtDob.text)?txtDob.text:@"" forKey:@"dob"];
    [_guestInfoDictionary setObject:(txtEmail.text)?txtEmail.text:@"" forKey:@"email"];
    
    [_guestInfoDictionary setObject:(txtCompanyName.text)?txtCompanyName.text:@"" forKey:@"companyname"];
    [_guestInfoDictionary setObject:(txtCountry.text)?txtCountry.text:@"" forKey:@"country"];
    [_guestInfoDictionary setObject:(txtAddress.text)?txtAddress.text:@"" forKey:@"address1"];
    
    [_guestInfoDictionary setObject:(txtCity.text)?txtCity.text:@"" forKey:@"city"];
    [_guestInfoDictionary setObject:(txtPostalCode.text)?txtPostalCode.text:@"" forKey:@"postalcode"];
    [_guestInfoDictionary setObject:(txtPhoneNumber.text)?txtPhoneNumber.text:@"" forKey:@"phoneno"];
    [_guestInfoDictionary setObject:(txtComments.text)?txtComments.text:@"" forKey:@"comments"];
    [_guestInfoDictionary setObject:@"PENDING" forKey:@"status"];

    if (![[AVHDataHandler sharedManager] bookingDataHolder]) {
        [[AVHDataHandler sharedManager] setBookingDataHolder:[NSMutableDictionary dictionary]];
    }
    
    [[[AVHDataHandler sharedManager] bookingDataHolder] setObject:_guestInfoDictionary forKey:GUEST_DETAILS];
}

- (NSMutableDictionary*)retrieveInformations {
    return [[[AVHDataHandler sharedManager] bookingDataHolder] objectForKey:GUEST_DETAILS];
}

- (void)enableEditMode{
    
    UIBarButtonItem *rightBarItem = [HelperClass getUpdateButton:self andAction:@selector(onUpdateData)];
    rightBarItem.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = rightBarItem;
    
    [self.navigationItem setHidesBackButton:YES];
    self.navigationItem.leftBarButtonItem = nil;
}

- (void)onUpdateData{
    
    [self saveInformations];
    //navigate back to review page
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Picker Component Delegate

- (void)didPickerSelectForRowAtIndex:(int)index andTag:(int)tag {
    
    
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

- (void)textViewDidBeginEditing:(UITextView *)textView {
    
    
    activeTextField = (UITextField *)textView;
    
    pinHeightConstraint.constant = viewDefaultHeightPin + 250;
    
    [self.view layoutIfNeeded];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    //NSLog(@"Content Offset Y: %f", scrollView.contentOffset.y);
    //NSLog(@"Txt Y pos: %f", textField.frame.origin.y);
    
    activeTextField = textField;
    
    pinHeightConstraint.constant = viewDefaultHeightPin + 250;
    
    [self.view layoutIfNeeded];
    
    //[self autoScrolTextField:textField];
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

- (void) autoScrolTextField: (UITextField *) textField  {
    
    //NSLog(@"Txt Y pos: %f", textField.frame.origin.y);
    
    //[scrollView setContentOffset:CGPointMake(0, 200) animated:YES];
    
    float slidePoint = 0.0f;
    float keyBoard_Y_Origin = self.view.bounds.size.height - 216.0f;
    float textFieldBottomPoint = textField.superview.frame.origin.y + (textField.frame.origin.y + textField.frame.size.height);
    float textFldValidationPoint = textFieldBottomPoint - scrollView.contentOffset.y;
    
    NSLog(@"KeyBY : %f, txtValidPoint : %f", keyBoard_Y_Origin, textFldValidationPoint);
    
    if (keyBoard_Y_Origin < textFldValidationPoint) {
        NSLog(@"Before Content Offset Y: %f", scrollView.contentOffset.y);
        
        //slidePoint = textFieldBottomPoint - keyBoard_Y_Origin + 10.0f;
        slidePoint = textFieldBottomPoint + keyBoard_Y_Origin;
        CGPoint point = CGPointMake(0.0f, slidePoint);
        [scrollView setContentOffset:point animated:YES];
        
        NSLog(@"After Content Offset Y: %f", scrollView.contentOffset.y);
    }
}

@end
