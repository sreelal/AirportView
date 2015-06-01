//
//  AVHOfferCell.h
//  AVH
//
//  Created by Sreelash S on 31/05/15.
//  Copyright (c) 2015 Sreelal H. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AVHOfferCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *infoImage;
@property (weak, nonatomic) IBOutlet UILabel *offerTitle;
@property (weak, nonatomic) IBOutlet UILabel *offerMessage;
@property (weak, nonatomic) IBOutlet UILabel *offerValidity;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activity;

- (void)loadInfoImageWithURL:(NSString *)imageURL;

@end
