//
//  SFInputAccessoryBar.h
//  Samsfirma
//
//  Created by Sreelash S on 26/04/15.
//  Copyright (c) 2015 Sreelal H. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ToolbarDelegate <NSObject>
@optional
- (void)toolBarDoneAction;
- (void)toolBarCancelAction;

@end

@interface InputAccessoryBar : UIView {
    IBOutlet UIButton *cancelBtn;
    IBOutlet UIButton *doneBtn;
}

@property (nonatomic, weak) id <ToolbarDelegate> delegate;

@end
