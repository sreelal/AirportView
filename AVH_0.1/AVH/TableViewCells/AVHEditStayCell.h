//
//  AVHEditStayCell.h
//  AVH
//
//  Created by Sreelal H on 02/06/15.
//  Copyright (c) 2015 Sreelal H. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AVHEditStayCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *checkinDate;
@property (weak, nonatomic) IBOutlet UILabel *checkoutDate;
@property (weak, nonatomic) IBOutlet UILabel *adultsValue;
@property (weak, nonatomic) IBOutlet UILabel *childrenValue;
@property (weak, nonatomic) IBOutlet UILabel *roomsValue;
@property (weak, nonatomic) IBOutlet UIButton *editButton;

@end
