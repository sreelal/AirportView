//
//  FBTableViewCell.m
//  CompuGhana
//
//  Created by Sreelal  Hamsavahanan on 09/03/15.
//  Copyright (c) 2015 Sreelal H. All rights reserved.
//

#import "FBTableViewCell.h"
#import "HelperClass.h"

@implementation FBTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)setBlueTheme{
    
    self.commentsText.textColor = [UIColor whiteColor];
    self.likesText.textColor = [UIColor whiteColor];
    self.postText.textColor = [UIColor whiteColor];
    self.contentView.backgroundColor = [HelperClass colorFromHexString:APP_THEME];
}

- (void)setWhiteTheme{
    
    self.commentsText.textColor = [HelperClass colorFromHexString:APP_THEME];
    self.likesText.textColor = [HelperClass colorFromHexString:APP_THEME];
    self.postText.textColor = [HelperClass colorFromHexString:APP_THEME];
    self.contentView.backgroundColor = [UIColor whiteColor];
}

@end
