//
//  AVHContactUsViewController.h
//  AVH
//
//  Created by Sreelash S on 03/06/15.
//  Copyright (c) 2015 Sreelal H. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AVHContactUsViewController : UIViewController <UITextFieldDelegate, UITextViewDelegate> {
    
    IBOutlet NSLayoutConstraint *pinHeightConstraint;
    IBOutlet UIScrollView *scrollView;
    
    IBOutlet UITextField *nameTxt;
    IBOutlet UITextField *emailTxt;
    IBOutlet UITextField *phoneTxt;
    IBOutlet UITextView  *descTxt;
}

@property (nonatomic, assign) BOOL isFromMenu;

@end
