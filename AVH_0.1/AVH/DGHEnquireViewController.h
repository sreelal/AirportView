//
//  DGHEnquireViewController.h
//  DeviceGH
//
//  Created by Sreelash S on 21/01/15.
//  Copyright (c) 2015 Sreelal H. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DGHEnquireViewController : UIViewController <UITextFieldDelegate, UITextViewDelegate> {
    
    IBOutlet UIView *enquiryListView;
    IBOutlet UIView *sendEnquiryView;
    IBOutlet UIScrollView *sendEnqScrollView;
    IBOutlet UICollectionView *productListView;
    IBOutlet UISegmentedControl *segementControl;
    
    IBOutlet UITextField *nameTextField;
    IBOutlet UITextField *emailTextField;
    IBOutlet UITextField *phoneTextField;
    IBOutlet UITextView  *detailsTextView;
    IBOutlet UIButton    *sendBtn;
}

@property (weak, nonatomic)   id activeField;
@property (strong, nonatomic) NSMutableArray  *products;
@property (assign, nonatomic) BOOL isFromMenu;

@end
