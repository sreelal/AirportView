//
//  WeatherTableViewCell.h
//  AVH
//
//  Created by Sreelal H on 12/05/15.
//  Copyright (c) 2015 Sreelal H. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WeatherTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *dewPointValue;
@property (weak, nonatomic) IBOutlet UILabel *temperatureCelsius;

@end
