//
//  FlightInfoTableViewCell.h
//  AVH
//
//  Created by Anamika on 5/13/15.
//  Copyright (c) 2015 Sreelal H. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FlightInfoTableViewCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel *flightNameLbl;
@property (nonatomic, strong) IBOutlet UILabel *flighNumberLbl;
@property (nonatomic, strong) IBOutlet UILabel *flightStatusLbl;
@property (nonatomic, strong) IBOutlet UILabel *arrivalLbl;
@property (nonatomic, strong) IBOutlet UILabel *departureLbl;

@end
