//
//  AVHEditGuestsCell.h
//  AVH
//
//  Created by Sreelal H on 02/06/15.
//  Copyright (c) 2015 Sreelal H. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AVHEditGuestsCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleValue;

@property (weak, nonatomic) IBOutlet UILabel *firstnameValue;
@property (weak, nonatomic) IBOutlet UILabel *lastnameValue;
@property (weak, nonatomic) IBOutlet UILabel *dobValue;
@property (weak, nonatomic) IBOutlet UILabel *emailValue;
@property (weak, nonatomic) IBOutlet UILabel *companyNameValue;
@property (weak, nonatomic) IBOutlet UILabel *countryValue;
@property (weak, nonatomic) IBOutlet UILabel *cityValue;
@property (weak, nonatomic) IBOutlet UILabel *postalcodeValue;

@property (weak, nonatomic) IBOutlet UILabel *phoneValue;
@property (weak, nonatomic) IBOutlet UILabel *addressValue;

@property (weak, nonatomic) IBOutlet UIButton *editButton;
@end
