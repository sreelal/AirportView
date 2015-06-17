//
//  TripAdvisorCell.h
//  AVH
//
//  Created by Sreelash S on 17/06/15.
//  Copyright (c) 2015 Sreelal H. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TripAdvisorCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *reviewImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UILabel *nameLbt;
@property (weak, nonatomic) IBOutlet UILabel *stayLbl;
@property (weak, nonatomic) IBOutlet UILabel *reviewLbl;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activity;

- (void)loadReviewImageWithURL:(NSString *)imageURL;

@end
