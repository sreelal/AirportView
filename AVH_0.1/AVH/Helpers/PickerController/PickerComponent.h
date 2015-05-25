//
//  PickerComponent.h
//  V.alert
//
//  Created by L & T Infotech on 25/10/14.
//  Copyright (c) 2014 Ashok. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PickerComponentDelegate <NSObject>
@required
- (void)didPickerSelectForRowAtIndex:(int)index andTag:(int)tag;
@optional
- (void)didSelectedDate:(NSDate *)date andTag:(int)tag;
- (void)didPickerCancel;
@end

@interface PickerComponent : UIView <UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, assign) long int tag;
@property (nonatomic, strong) NSMutableArray *data;
@property (nonatomic, assign) id <PickerComponentDelegate> delegate;

- (instancetype)initWithData:(NSMutableArray *)data;
- (instancetype)initWithFrame:(CGRect)frame andDelegate:(id)target andData:(NSMutableArray *)data withTag:(long int)tag;
//- (instancetype)initWithFrame:(CGRect)frame forDatePicker:(BOOL)isDatePicker andDelegate:(id)target withTag:(int)tag;
- (instancetype)initWithFrame:(CGRect)frame forSelectedDate:(NSDate *)selDate andDelegate:(id)target withTag:(long int)tag;

@end
