//
//  AVHHotelCellTableViewCell.h
//  AVH
//
//  Created by Sreelal  Hamsavahanan on 25/05/15.
//  Copyright (c) 2015 Sreelal H. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AVHHotelCellTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *hotelImage;
@property (weak, nonatomic) IBOutlet UILabel *hotelRate;
@property (weak, nonatomic) IBOutlet UILabel *hotelduration;
@property (weak, nonatomic) IBOutlet UITextView *hotelDescription;

@property (weak, nonatomic) IBOutlet UIButton *hotelBookNowBtn;
@end
