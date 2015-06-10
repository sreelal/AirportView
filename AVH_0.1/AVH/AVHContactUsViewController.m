//
//  AVHContactUsViewController.m
//  AVH
//
//  Created by Sreelash S on 03/06/15.
//  Copyright (c) 2015 Sreelal H. All rights reserved.
//

#import "AVHContactUsViewController.h"
#import "HelperClass.h"
#import "InputAccessoryBar.h"
#import "AppDelegate.h"
#import "WebHandler.h"

@interface AVHContactUsViewController () <ToolbarDelegate>

@property (nonatomic, assign) BOOL isViewPopped;
@property (nonatomic, strong) UITextField *activeTextField;

@end

@implementation AVHContactUsViewController
@synthesize activeTextField;
@synthesize isFromMenu;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"AVH_logo.png"]];
    
    UIBarButtonItem *leftBarItem = [HelperClass getBackButtonItemWithTarget:self andAction:@selector(navgationBackClicked:)];
    leftBarItem.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = leftBarItem;
    
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    
    [self setContentViewHeight:0];
    
    //Setting input accessory view for Searchbar//
    nameTxt.inputAccessoryView = [self getInputAccesory];
    phoneTxt.inputAccessoryView = [self getInputAccesory];
    descTxt.inputAccessoryView = [self getInputAccesory];
    //////////////////////////////////////////////////////
    
    descTxt.layer.cornerRadius = 5.0f;
    descTxt.layer.borderWidth = 0.5f;
    descTxt.layer.borderColor = [[UIColor lightGrayColor] CGColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Helper Methods

- (BOOL)validateInputs{
    
    BOOL isSuccess = YES;
    
    if ([nameTxt.text length]<=0) {
        isSuccess = NO;
    }
    if([emailTxt.text length]<=0) {
        isSuccess = NO;
    }
    if([phoneTxt.text length]<=0) {
        isSuccess = NO;
    }
    if([descTxt.text length]<=0) {
        isSuccess = NO;
    }
    
    if (!isSuccess) {
        UIAlertView *_alert = [[UIAlertView alloc] initWithTitle:@""
                                                         message:[NSString stringWithFormat:@"Please enter all the informations to send"]
                                                        delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [_alert show];
    }
    
    return isSuccess;
}

- (InputAccessoryBar *)getInputAccesory {
    
    InputAccessoryBar *inputAccessoryBar = [[NSBundle mainBundle] loadNibNamed:@"InputAccessoryBar" owner:self options:nil][0];
    inputAccessoryBar.delegate = self;
    inputAccessoryBar.frame = CGRectMake(inputAccessoryBar.frame.origin.x, inputAccessoryBar.frame.origin.y, [UIScreen mainScreen].bounds.size.width, inputAccessoryBar.frame.size.height);
    
    return inputAccessoryBar;
}

- (void)setContentViewHeight:(CGFloat)ht {
    
    CGFloat viewHt = [UIScreen mainScreen].bounds.size.height + ht;
    pinHeightConstraint.constant = viewHt;
    [self.view layoutIfNeeded];
}

#pragma mark - Button Actions

- (IBAction)sendEnquiryAction:(id)sender {
    
    if (![self validateInputs]) {
        return;
    }
    
    [self resignFirstResponder];
    
    [[AppDelegate instance] showBusyView:@"Loading..."];
    
    NSDictionary *enqDict = [NSDictionary dictionaryWithObjectsAndKeys:nameTxt.text, @"name", emailTxt.text, @"email", phoneTxt.text, @"phone", nil];
    
    NSLog(@"Subscribe Array : %@", enqDict);
    
    [WebHandler sendEnquiryWithDict:enqDict withCallback:^(id object, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [[AppDelegate instance] hideBusyView];
            
            NSString *message;
            
            if (error == nil) {
                message = object[@"success"];
                
                nameTxt.text  = @"";
                emailTxt.text = @"";
                phoneTxt.text = @"";
                descTxt.text  = @"";
            }
            else {
                message = @"Subscription Failed.";
            }
            
            UIAlertView *_alert = [[UIAlertView alloc] initWithTitle:@""
                                                             message:message
                                                            delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [_alert show];
        });
    }];
}

- (void)navgationBackClicked:(id)sender {
    
    if (isFromMenu) {
        [self.sideMenuViewController setContentViewController:[AppDelegate instance].homeVC];
        [self.sideMenuViewController hideMenuViewController];
    }
    else {
        _isViewPopped = YES;
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - UITextField Delegate

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    activeTextField = textField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    activeTextField = nil;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    
    return YES;
}

#pragma mark - UITextView Delegate

- (void)textViewDidBeginEditing:(UITextView *)textView {
    activeTextField = textView;
    
    NSLog(@"Offset : %f", scrollView.contentOffset.y);
    
    [self setContentViewHeight:80];
    
    
    [scrollView setContentOffset:CGPointMake(0, 100) animated:YES];
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    activeTextField = nil;
    
    [scrollView setContentOffset:CGPointMake(0, 40) animated:YES];
    
    [self setContentViewHeight:0];
}

#pragma mark - Toolbar delegate

- (void)toolBarDoneAction {
    [activeTextField resignFirstResponder];
    
    [self sendEnquiryAction:nil];
    
    activeTextField = nil;
}

- (void)toolBarCancelAction {
    
    [activeTextField resignFirstResponder];
    
    activeTextField = nil;
}

@end
