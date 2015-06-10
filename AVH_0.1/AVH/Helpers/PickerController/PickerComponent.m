//
//  PickerComponent.m
//  V.alert
//
//  Created by L & T Infotech on 25/10/14.
//  Copyright (c) 2014 Ashok. All rights reserved.
//

#import "PickerComponent.h"
#import "AppDelegate.h"

@interface PickerComponent () {
    
    UIView *containerView;
    UIView *bgView;
    UIView *bgPicker;
    
    UIPickerView *pickerControlView;
    UIDatePicker *datePickerView;
}

@property (nonatomic, strong) UIBarButtonItem *doneBarButtonItem;
@property (nonatomic, strong) UIBarButtonItem *cancelBarButtonItem;
@property (nonatomic, strong) UIToolbar *toolbar;
@property (nonatomic, assign) long int selectedIndex;
@property (nonatomic, assign) BOOL isDatePickerComponent;
@property (nonatomic, strong) NSDate *selectedDate;

@end

@implementation PickerComponent
@synthesize delegate;

- (instancetype)initWithData:(NSMutableArray *)data {
    
    self = [super init];
    
    if (self) {
        CGRect frame = [UIScreen mainScreen].bounds;
        
        self.data = data;
        self.selectedIndex = 0;
        
        [self createControlForDatePicker:NO withFrame:frame];
  
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame andDelegate:(id)target andData:(NSMutableArray *)data withTag:(long int)tag {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        self.tag = tag;
        self.data = data;
        self.delegate = target;
        
        self.backgroundColor = [UIColor clearColor];
        
        //Creating bg
        containerView = [[UIView alloc] initWithFrame:frame];
        containerView.alpha = 0;
        bgView = [[UIView alloc] initWithFrame:frame];
        bgView.backgroundColor = [UIColor whiteColor];
        bgView.alpha = 0.7;
        //////////////////////////////////////////////////////
        
        //Creating Toolbar
        UIBarButtonItem *sysDoneButton = [self createButtonWithTitle:NSLocalizedString(@"Done  ", nil) target:self action:@selector(actionPickerDone:)];
        
        UIBarButtonItem *sysCancelButton = [self createButtonWithTitle:NSLocalizedString(@"  Cancel", nil) target:self
                                                               action:@selector(actionPickerCancel:)];
        
        [self setCancelBarButtonItem:sysCancelButton];
        [self setDoneBarButtonItem:sysDoneButton];
        
        self.toolbar = [self createPickerToolbarWithTitle:nil];
        ////////////////////////////////////////////////////////////////////////////////////////
        
        //Creating Picker
        bgPicker = [[UIView alloc]  initWithFrame:CGRectMake(0, frame.size.height - 216, frame.size.width, 216)];
        bgPicker.backgroundColor = [UIColor whiteColor];
        pickerControlView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, frame.size.height - 216, frame.size.width, 216)];
        pickerControlView.delegate   = self;
        pickerControlView.dataSource = self;
        
        [self addSubview:containerView];
        [containerView addSubview:bgView];
        [containerView addSubview:bgPicker];
        [containerView addSubview:pickerControlView];
        [containerView addSubview:self.toolbar];
        
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [appDelegate.window addSubview:self];
        
        [self showPickerView:YES];
        //////////////////////////////////////////////////////
    }
    
    return self;
}

//- (instancetype)initWithFrame:(CGRect)frame forDatePicker:(BOOL)isDatePicker andDelegate:(id)target withTag:(int)tag {
- (instancetype)initWithFrame:(CGRect)frame forSelectedDate:(NSDate *)selDate andMinDate:(NSDate *)minDate andDelegate:(id)target withTag:(long int)tag {

    self = [super initWithFrame:frame];
    
    if (self) {
        self.tag = tag;
        self.delegate = target;
        self.isDatePickerComponent = YES;
        self.selectedDate = selDate;//[self getStringDateFrom:[NSDate date]];
        
        self.backgroundColor = [UIColor clearColor];
        
        //Creating bg
        containerView = [[UIView alloc] initWithFrame:frame];
        containerView.alpha = 0;
        bgView = [[UIView alloc] initWithFrame:frame];
        bgView.backgroundColor = [UIColor whiteColor];
        bgView.alpha = 0.7;
        //////////////////////////////////////////////////////
        
        //Creating Toolbar
        UIBarButtonItem *sysDoneButton = [self createButtonWithTitle:NSLocalizedString(@"Done  ", nil) target:self action:@selector(actionPickerDone:)];
        
        UIBarButtonItem *sysCancelButton = [self createButtonWithTitle:NSLocalizedString(@"  Cancel", nil) target:self
                                                                action:@selector(actionPickerCancel:)];
        
        [self setCancelBarButtonItem:sysCancelButton];
        [self setDoneBarButtonItem:sysDoneButton];
        
        self.toolbar = [self createPickerToolbarWithTitle:nil];
        ////////////////////////////////////////////////////////////////////////////////////////
        
        //Creating Picker
        bgPicker = [[UIView alloc]  initWithFrame:CGRectMake(0, frame.size.height - 216, frame.size.width, 216)];
        bgPicker.backgroundColor = [UIColor whiteColor];
        
        datePickerView = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, frame.size.height - 216, frame.size.width, 216)];
        datePickerView.datePickerMode = UIDatePickerModeDate;
        datePickerView.date = selDate;
        
        if (minDate)
            datePickerView.minimumDate = [NSDate date];
        
        [datePickerView addTarget:self
                           action:@selector(dateChange:)
                 forControlEvents:UIControlEventValueChanged];
        
        [containerView addSubview:bgView];
        [containerView addSubview:bgPicker];
        
        [containerView addSubview:self.toolbar];
        [containerView addSubview:datePickerView];
        
        [self addSubview:containerView];
        
        UIWindow* window = [[UIApplication sharedApplication] keyWindow];
        [window addSubview:self];
        
        //AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        //[appDelegate.window addSubview:self];
        
        [self showPickerView:YES];
        //////////////////////////////////////////////////////
    }
    return self;
}

#pragma mark - UIPickerViewDelegate / DataSource

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.selectedIndex = row;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.data.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    id obj = (self.data)[(NSUInteger) row];
    
    // return the object if it is already a NSString,
    // otherwise, return the description, just like the toString() method in Java
    // else, return nil to prevent exception
    
    if ([obj isKindOfClass:[NSString class]])
        return obj;
    
    if ([obj respondsToSelector:@selector(description)])
        return [obj performSelector:@selector(description)];
    
    return nil;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    return pickerView.frame.size.width - 30;
}

#pragma mark - Helper Methods

- (void)createControlForDatePicker:(BOOL)isDatePicker withFrame:(CGRect)frame {
    
    self.backgroundColor = [UIColor clearColor];
    
    //Creating bg
    containerView = [[UIView alloc] initWithFrame:frame];
    containerView.alpha = 0;
    bgView = [[UIView alloc] initWithFrame:frame];
    bgView.backgroundColor = [UIColor whiteColor];
    bgView.alpha = 0.7;
    //////////////////////////////////////////////////////
    
    //Creating Toolbar
    UIBarButtonItem *sysDoneButton = [self createButtonWithTitle:@"Done" target:self action:@selector(actionPickerDone:)];
    
    UIBarButtonItem *sysCancelButton = [self createButtonWithTitle:@"Cancel" target:self
                                                            action:@selector(actionPickerCancel:)];
    
    [self setCancelBarButtonItem:sysCancelButton];
    [self setDoneBarButtonItem:sysDoneButton];
    
    self.toolbar = [self createPickerToolbarWithTitle:nil];
    ////////////////////////////////////////////////////////////////////////////////////////
    
    //Creating Picker
    bgPicker = [[UIView alloc]  initWithFrame:CGRectMake(0, frame.size.height - 216, frame.size.width, 216)];
    bgPicker.backgroundColor = [UIColor whiteColor];
    
    if (isDatePicker) {
        datePickerView.datePickerMode = UIDatePickerModeDate;
        datePickerView.date = [NSDate date];
        
        [datePickerView addTarget:self
                       action:@selector(dateChange:)
             forControlEvents:UIControlEventValueChanged];
        [containerView addSubview:datePickerView];
    }
    else {
        self.selectedIndex = 0;
        
        pickerControlView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, frame.size.height - 216, frame.size.width, 216)];
        pickerControlView.delegate   = self;
        pickerControlView.dataSource = self;
        
        [containerView addSubview:pickerControlView];
    }
    
    [self addSubview:containerView];
    [containerView addSubview:bgView];
    [containerView addSubview:bgPicker];
    
    [containerView addSubview:self.toolbar];
    
    [self showPickerView:YES];
    //////////////////////////////////////////////////////
}

- (UIToolbar *)createPickerToolbarWithTitle:(NSString *)title {
    
    CGRect frame = CGRectMake(0, self.frame.size.height - 260, self.frame.size.width, 44);
    UIToolbar *pickerToolbar = [[UIToolbar alloc] initWithFrame:frame];
    pickerToolbar.barStyle = (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_6_1) ? UIBarStyleDefault : UIBarStyleBlackTranslucent;
    
    NSMutableArray *barItems = [[NSMutableArray alloc] init];
    
    [barItems addObject:self.cancelBarButtonItem];
    
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [barItems addObject:flexSpace];
    
    [barItems addObject:self.doneBarButtonItem];
    
    [pickerToolbar setItems:barItems animated:NO];
    
    return pickerToolbar;
}

- (UIBarButtonItem *)createButtonWithTitle:(NSString *)title target:(id)target action:(SEL)buttonAction {
    
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStyleDone target:target action:buttonAction];
    
    [barButton setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                    [UIColor darkGrayColor], NSForegroundColorAttributeName,nil]
                                                    forState:UIControlStateNormal];
    
    return barButton;
}

- (void)showPickerView:(BOOL)isShow {
    
    int alpha;
    
    if (isShow) alpha = 1;
    else alpha = 0;
    
    [UIView animateWithDuration:0.2 animations:^{
        containerView.alpha = alpha;
    } completion:^(BOOL finished) {
        if (!isShow)
            [self removeFromSuperview];
    }];
}

#pragma mark - Button Actions 

- (void)dateChange:(id)sender {
    
    self.selectedDate = datePickerView.date;//[self getStringDateFrom:datePickerView.date];
}

- (IBAction)actionPickerDone:(id)sender {
    
    if (self.isDatePickerComponent) {
        if ([self.delegate respondsToSelector:@selector(didSelectedDate:andTag:)]) {
            [self.delegate didSelectedDate:self.selectedDate andTag:self.tag];
        }
    }
    else {
        if ([self.delegate respondsToSelector:@selector(didPickerSelectForRowAtIndex:andTag:)]) {
            [self.delegate didPickerSelectForRowAtIndex:self.selectedIndex andTag:self.tag];
        }
    }
    
    [self showPickerView:NO];
}

- (IBAction)actionPickerCancel:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(didPickerCancel)]) {
        [self.delegate didPickerCancel];
    }
    
    [self showPickerView:NO];
}

- (NSString *)getStringDateFrom:(NSDate *)date {
    
    NSString *strDate;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setFormatterBehavior:NSDateFormatterBehavior10_4];
    [formatter setDateFormat:@"dd/MM/yyyy"];
    
    strDate = [NSString stringWithFormat:@"%@",
                         [formatter stringFromDate:date]];
    
    return strDate;
}


@end
