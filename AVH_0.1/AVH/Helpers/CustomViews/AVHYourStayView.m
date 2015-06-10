//
//  AVHYourStayView.m
//  AVH
//
//  Created by Sreelal H on 24/05/15.
//  Copyright (c) 2015 Sreelal H. All rights reserved.
//

#import "AVHYourStayView.h"
#import "Constants.h"
#import "HelperClass.h"

@implementation AVHYourStayView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib {
    
    NSLog(@"Your Stay loaded");
    
    checkInTxt.text  = [HelperClass getCurrentDateWithFormat:DATE_FORMAT_MM_DD_YYYY];
    checkOutTxt.text = [HelperClass getNextDayDateWithFormat:DATE_FORMAT_MM_DD_YYYY];
    adultsTxt.text   = roomsTxt.text = @"1";
    childrenTxt.text = @"0";
    
    pickerNumberData = [[NSMutableArray alloc] init];
    
    for (int i=0; i<=100; i++) {
        [pickerNumberData addObject:[NSString stringWithFormat:@"%d", i]];
    }
}

#pragma mark - Button Actions

- (IBAction)showDatePicker:(id)sender {
    
    UIButton *btn     = (UIButton *)sender;
    NSDate   *selDate;
    
    if (btn.tag == 0)
        selDate = [HelperClass getNSDateFromString:checkInTxt.text withFormat:DATE_FORMAT_MM_DD_YYYY];
    else
        selDate = [HelperClass getNSDateFromString:checkOutTxt.text withFormat:DATE_FORMAT_MM_DD_YYYY];
    
    pickerComponent = [[PickerComponent alloc] initWithFrame:[UIScreen mainScreen].bounds forSelectedDate:selDate andMinDate:[NSDate date]  andDelegate:self withTag:btn.tag];
}

- (IBAction)showNumberPicker:(id)sender {
    
    UIButton *btn     = (UIButton *)sender;
    
    pickerComponent = [[PickerComponent alloc] initWithFrame:[UIScreen mainScreen].bounds andDelegate:self andData:pickerNumberData withTag:btn.tag];
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

@end
