//
//  SFInputAccessoryBar.m
//  Samsfirma
//
//  Created by Sreelash S on 26/04/15.
//  Copyright (c) 2015 Sreelal H. All rights reserved.
//

#import "InputAccessoryBar.h"

@implementation InputAccessoryBar

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (IBAction)cancelAction:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(toolBarCancelAction)]) {
        [self.delegate toolBarCancelAction];
    }
}

- (IBAction)doneAction:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(toolBarDoneAction)]) {
        [self.delegate toolBarDoneAction];
    }
}

@end
