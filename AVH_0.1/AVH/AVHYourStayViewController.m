//
//  AVHYourStayViewController.m
//  AVH
//
//  Created by Anamika on 5/26/15.
//  Copyright (c) 2015 Sreelal H. All rights reserved.
//

#import "AVHYourStayViewController.h"
#import "Constants.h"
#import "HelperClass.h"

@interface AVHYourStayViewController ()

@end

@implementation AVHYourStayViewController

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
    
    checkInTxt.text  = [HelperClass getCurrentDateWithFormat:DATE_FORMAT_MM_DD_YYYY];
    checkOutTxt.text = [HelperClass getNextDayDateWithFormat:DATE_FORMAT_MM_DD_YYYY];
    adultsTxt.text   = roomsTxt.text = @"1";
    childrenTxt.text = @"0";
    
    pickerNumberData = [[NSMutableArray alloc] init];
    
    for (int i=0; i<=100; i++) {
        [pickerNumberData addObject:[NSString stringWithFormat:@"%d", i]];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Button Actions

- (IBAction)showDatePicker:(id)sender {
    
    UIButton *btn     = (UIButton *)sender;
    NSDate   *selDate;
    
    if (btn.tag == 0)
        selDate = [HelperClass getNSDateFromString:checkInTxt.text withFormat:DATE_FORMAT_MM_DD_YYYY];
    else
        selDate = [HelperClass getNSDateFromString:checkOutTxt.text withFormat:DATE_FORMAT_MM_DD_YYYY];
    
    pickerComponent = [[PickerComponent alloc] initWithFrame:[UIScreen mainScreen].bounds forSelectedDate:selDate andDelegate:self withTag:btn.tag];
}

- (IBAction)showNumberPicker:(id)sender {
    
    UIButton *btn     = (UIButton *)sender;
    
    pickerComponent = [[PickerComponent alloc] initWithFrame:[UIScreen mainScreen].bounds andDelegate:self andData:pickerNumberData withTag:btn.tag];
}

- (void)navgationBackClicked:(id)sender {
    
    //_isViewPopped = YES;
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)navgationNextClicked:(id)sender {
    
    //_guestDetailsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"GuestDetailsVC"];
    
    //[self.navigationController pushViewController:_guestDetailsVC animated:YES];
    
    //_guestDetailsVC = nil;
    //[_swipeView scrollToPage:1 duration:0.5];
}

#pragma mark - Picker Component Delegate

- (void)didPickerSelectForRowAtIndex:(int)index andTag:(int)tag {
    
    NSLog(@"Selected Index: %d", index);
    
    NSString *selectedData = [pickerNumberData objectAtIndex:index];
    
    if (tag == 2)
        adultsTxt.text = selectedData;
    else if (tag == 3)
        childrenTxt.text = selectedData;
    else
        roomsTxt.text = selectedData;
    
    pickerComponent = nil;
}

- (void)didSelectedDate:(NSDate *)date andTag:(int)tag {
    
    NSLog(@"Date Selected: %@", [HelperClass getStringDateFromNSDate:date withFormat:DATE_FORMAT_MM_DD_YYYY]);
    
    if (tag == 0)
        checkInTxt.text = [HelperClass getStringDateFromNSDate:date withFormat:DATE_FORMAT_MM_DD_YYYY];
    else
        checkOutTxt.text = [HelperClass getStringDateFromNSDate:date withFormat:DATE_FORMAT_MM_DD_YYYY];
    
    pickerComponent = nil;
}

- (void)didPickerCancel {
    
    NSLog(@"Picker Cancelled");
    
    pickerComponent = nil;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
