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

@end
