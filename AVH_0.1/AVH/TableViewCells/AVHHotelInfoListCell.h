//
//  AVHHotelInfoListCell.h
//  AVH
//
//  Created by Sreelash S on 30/05/15.
//  Copyright (c) 2015 Sreelal H. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AVHHotelInfoListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *infoImage;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activity;

- (void)loadInfoImageWithURL:(NSString *)imageURL;

@end
