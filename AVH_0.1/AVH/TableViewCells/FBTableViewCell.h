//
//  FBTableViewCell.h
//  CompuGhana
//
//  Created by Sreelal  Hamsavahanan on 09/03/15.
//  Copyright (c) 2015 Sreelal H. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FBTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *postText;
@property (weak, nonatomic) IBOutlet UILabel *commentsText;
@property (weak, nonatomic) IBOutlet UILabel *likesText;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityView;

@property (weak, nonatomic) IBOutlet UIImageView *iconImage;

- (void)setBlueTheme;
- (void)setWhiteTheme;
@end
