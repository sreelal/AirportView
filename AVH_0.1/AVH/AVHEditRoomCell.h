//
//  AVHEditRoomCell.h
//  AVH
//
//  Created by Sreelal H on 02/06/15.
//  Copyright (c) 2015 Sreelal H. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AVHEditRoomCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *roomImage;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityView;
@property (weak, nonatomic) IBOutlet UITextView *roomDescription;
@property (weak, nonatomic) IBOutlet UILabel *titleValue;
@property (weak, nonatomic) IBOutlet UIButton *editButton;
@property (weak, nonatomic) IBOutlet UILabel *roomPrice;

- (void)loadHotelImageFrom:(NSString*)imageURL;
@end
