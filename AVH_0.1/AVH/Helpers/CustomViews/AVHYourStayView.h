//
//  AVHYourStayView.h
//  AVH
//
//  Created by Sreelal H on 24/05/15.
//  Copyright (c) 2015 Sreelal H. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PickerComponent.h"

@interface AVHYourStayView : UIView {
    
    IBOutlet UITextField *checkInTxt;
    IBOutlet UITextField *checkOutTxt;
    IBOutlet UITextField *adultsTxt;
    IBOutlet UITextField *childrenTxt;
    IBOutlet UITextField *roomsTxt;
    
    PickerComponent *pickerComponent;
    NSMutableArray *pickerNumberData;
}

@end
