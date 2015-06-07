//
//  AVHYourStayViewController.h
//  AVH
//
//  Created by Anamika on 5/26/15.
//  Copyright (c) 2015 Sreelal H. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PickerComponent.h"
#import "RESideMenu.h"

@interface AVHYourStayViewController : UIViewController {
    
    IBOutlet UITextField *checkInTxt;
    IBOutlet UITextField *checkOutTxt;
    IBOutlet UITextField *adultsTxt;
    IBOutlet UITextField *childrenTxt;
    IBOutlet UITextField *roomsTxt;
    
    PickerComponent *pickerComponent;
    NSMutableArray *pickerNumberData;
}

@end
