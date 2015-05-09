//
//  DGHEnquireViewController.m
//  DeviceGH
//
//  Created by Sreelash S on 21/01/15.
//  Copyright (c) 2015 Sreelal H. All rights reserved.
//

#import "DGHEnquireViewController.h"
#import "DGHProductInfoViewController.h"
#import "DGHProductCell.h"
#import "CacheManager.h"
#import "WebHandler.h"
#import "AppDelegate.h"
#import "HelperClass.h"

@interface DGHEnquireViewController ()<ProductCellDelegate>

@end

@implementation DGHEnquireViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    nameTextField.delegate = self;
    emailTextField.delegate = self;
    phoneTextField.delegate = self;
    detailsTextView.delegate = self;
    
    //set input accessorview
    nameTextField.inputAccessoryView = [self getInputAccessoryView];
    emailTextField.inputAccessoryView = [self getInputAccessoryView];
    phoneTextField.inputAccessoryView = [self getInputAccessoryView];
    detailsTextView.inputAccessoryView = [self getInputAccessoryView];

    self.products = [[CacheManager sharedInstance] enquiryProducts];
    
    sendEnquiryView.hidden = YES;
    enquiryListView.hidden = NO;
    
    segementControl.tintColor = [UIColor colorWithPatternImage: [UIImage imageNamed: @"NavigationBg.png"]];
    segementControl.backgroundColor = [UIColor whiteColor];
    
    [segementControl addTarget:self
                         action:@selector(segmentSwitch:)
               forControlEvents:UIControlEventValueChanged];
    
    if (self.isFromMenu) {
        segementControl.selectedSegmentIndex = 1;
        
        sendEnquiryView.hidden = NO;
        enquiryListView.hidden = YES;
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShow:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Button Actions

- (IBAction)sendEnquiry:(id)sender {

    if (![self validateInputs]) {
        
        return;
    }
    
    
    [self resignFirstResponder];
    
    [[AppDelegate instance] showBusyView:@"Loading..."];
    
    NSMutableArray *prodIds = [[NSMutableArray alloc] init];
    NSMutableArray *enquiryProducts = [[CacheManager sharedInstance] enquiryProducts];
    
    [enquiryProducts enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        Product *product = (Product *)obj;
        
        [prodIds addObject:product.Id];
    }];
    
    NSDictionary *enquiryDict = [NSDictionary dictionaryWithObjectsAndKeys:nameTextField.text, @"name", emailTextField.text, @"email", phoneTextField.text, @"phoneNo", detailsTextView.text, @"enquiry", prodIds, @"productIds", nil];
    
    NSLog(@"Enquiry Dict : %@", enquiryDict);
    
    [WebHandler sendEnquiryWithDict:enquiryDict withCallback:^(id object, NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [[AppDelegate instance] hideBusyView];
        });
    }];
}

- (IBAction)segmentSwitch:(id)sender {
    
    UISegmentedControl *segmentedControl = (UISegmentedControl *) sender;
    NSInteger selectedSegment = segmentedControl.selectedSegmentIndex;
    
    if (selectedSegment == 0) {
        sendEnquiryView.hidden = YES;
        enquiryListView.hidden = NO;
    }
    else{
        sendEnquiryView.hidden = NO;
        enquiryListView.hidden = YES;
    }
}

#pragma mark - UICollectionView Delegates

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    
    return self.products.count;
}

- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    DGHProductCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"ProductCell" forIndexPath:indexPath];
    
    cell.delegate = self;
    
    Product *product = self.products[indexPath.row];
    
    cell.productNameLabel.text = product.name;
    
    [cell setupBg];
    
    [cell loadProductImageForProduct:product];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat pixel;
    CGSize size;
    
    if ([HelperClass isIphone6Plus]) pixel = 186;
    else pixel = [UIScreen mainScreen].bounds.size.width/2;
    
    size = CGSizeMake(pixel, 203);
    
    return size;
}

- (UIEdgeInsets)collectionView:
(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    UIEdgeInsets insets = UIEdgeInsetsMake(0, 0, 0, 0);;
    
    return insets;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    
    return 0.0f;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    
    return 0.0f;
}

#pragma mark - ProductCell Delegate

- (void)deleteProductFromEnquireList:(Product *)product {
    
    [[CacheManager sharedInstance] removeProduct:product];
    
    self.products = [[CacheManager sharedInstance] enquiryProducts];
    
    [productListView reloadData];
}

- (void)viewProductInfo:(Product *)product {
    
    UINavigationController *productInfoVCNav = [self.storyboard instantiateViewControllerWithIdentifier:@"ProductInfoViewNavigation"];
    DGHProductInfoViewController *productInfoView = [[productInfoVCNav viewControllers] firstObject];
    productInfoView.product = product;
    
    [self.sideMenuViewController setContentViewController:productInfoVCNav];
    [self.sideMenuViewController hideMenuViewController];
}

#pragma mark - UITextField Delegate

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.activeField = textField;
    //[self animateView:sendEnquiryView forStatus:YES];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    self.activeField = nil;
    //[self animateView:sendEnquiryView forStatus:NO];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    
    return YES;
}

#pragma mark - UITextView Delegate

- (void)textViewDidBeginEditing:(UITextView *)textView {
    self.activeField = textView;
    
    //[sendEnqScrollView setContentSize:CGSizeMake([UIScreen mainScreen].bounds.size.width, 800)];
    //[self animateView:sendEnquiryView forStatus:YES];
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    self.activeField = nil;
    
    //[sendEnqScrollView setContentSize:CGSizeMake([UIScreen mainScreen].bounds.size.width, 506)];
    //[self animateView:sendEnquiryView forStatus:NO];
}

#pragma mark - Helper Methods

- (void)animateView:(UIView *)view forStatus:(BOOL)isOpen {
    
    /*[UIView animateWithDuration:1.0 animations:^{
        CGRect frame;
        
        if (isOpen) frame = CGRectMake(view.frame.origin.x, -100, view.frame.size.width, view.frame.size.height);
        else frame = CGRectZero;
        
        view.frame = frame;
    }];*/
}

#pragma mark - Keyboard Notification

- (void) keyboardDidShow:(NSNotification *)notification
{
    NSDictionary* info = [notification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height+44, 0.0);
    sendEnqScrollView.contentInset = contentInsets;
    sendEnqScrollView.scrollIndicatorInsets = contentInsets;
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your application might not need or want this behavior.
    CGRect aRect = self.view.frame;
    aRect.size.height -= (kbSize.height);
    
    CGRect frame;
    if ([self.activeField isKindOfClass:[UITextField class]]) {
        UITextField *textField = (UITextField *)self.activeField;
        frame = textField.frame;
    }
    else {
        UITextView *textView = (UITextView *)self.activeField;
        frame = textView.frame;
    }
    
    if (!CGRectContainsPoint(aRect, frame.origin) ) {
        
#if APPLE_WAY
        CGPoint scrollPoint = CGPointMake(0.0, self.activeField.frame.origin.y-kbSize.height);
#else
        CGFloat offset = frame.origin.y;
        
        //TODO: Why is this off by 70?
        offset = offset - 70;
        
        CGPoint scrollPoint = CGPointMake(0.0, offset);
#endif
        [sendEnqScrollView setContentOffset:scrollPoint animated:YES];
    }
}

- (void) keyboardWillBeHidden:(NSNotification *)notification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    sendEnqScrollView.contentInset = contentInsets;
    sendEnqScrollView.scrollIndicatorInsets = contentInsets;
}



- (UIToolbar*)getInputAccessoryView{
    
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height, self.view.bounds.size.width, 44)];
    toolBar.barStyle = UIBarStyleBlack;
    toolBar.translucent = YES;
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneWriting:)];
    [toolBar setItems:[NSArray arrayWithObjects:doneButton, nil]];
    
    return toolBar;
}

#pragma mark - Button actions

- (void)doneWriting:(id)sender{
    
    [nameTextField resignFirstResponder];
    [emailTextField resignFirstResponder];
    [phoneTextField resignFirstResponder];
    [detailsTextView resignFirstResponder];
    
}


- (BOOL)validateInputs{
    
    BOOL isSuccess = YES;
    
    nameTextField.layer.borderWidth = 0.0;
    emailTextField.layer.borderWidth = 0.0;
    phoneTextField.layer.borderWidth = 0.0;
    detailsTextView.layer.borderWidth = 0.0;
    
    if ([nameTextField.text length]<=0) {
        
        nameTextField.layer.borderColor = [UIColor redColor].CGColor;
        nameTextField.layer.borderWidth = 1.0;
        isSuccess = NO;

    }
    if([emailTextField.text length]<=0){
        
        emailTextField.layer.borderColor = [UIColor redColor].CGColor;
        emailTextField.layer.borderWidth = 1.0;
        isSuccess = NO;
    }
    if([phoneTextField.text length]<=0){
        
        phoneTextField.layer.borderColor = [UIColor redColor].CGColor;
        phoneTextField.layer.borderWidth = 1.0;
        isSuccess = NO;
    }
    if([detailsTextView.text length]<=0){
        
        detailsTextView.layer.borderColor = [UIColor redColor].CGColor;
        detailsTextView.layer.borderWidth = 1.0;
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


@end
