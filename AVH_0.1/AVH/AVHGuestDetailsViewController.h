//
//  GuestDetailsViewController.h
//  AVH
//
//  Created by Anamika on 5/27/15.
//  Copyright (c) 2015 Sreelal H. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PickerComponent.h"

@interface AVHGuestDetailsViewController : UIViewController <UITextFieldDelegate, UITextViewDelegate> {
    
    IBOutlet NSLayoutConstraint *pinHeightConstraint;
    IBOutlet UIScrollView *scrollView;
    
    IBOutlet UITextField *txtTitle;
    IBOutlet UITextField *txtFirstName;
    IBOutlet UITextField *txtLastName;
    IBOutlet UITextField *txtDob;
    IBOutlet UITextField *txtEmail;
    IBOutlet UITextField *txtCompanyName;
    IBOutlet UITextField *txtCountry;
    IBOutlet UITextField *txtAddress;
    IBOutlet UITextField *txtCity;
    IBOutlet UITextField *txtPostalCode;
    IBOutlet UITextField *txtPhoneNumber;
    IBOutlet UITextView *txtComments;
    IBOutlet UIButton *btnTitle;
    IBOutlet UIButton *btnDob;
    IBOutlet UIButton *btnCountry;
    
    PickerComponent *pickerComponent;
}

@end
