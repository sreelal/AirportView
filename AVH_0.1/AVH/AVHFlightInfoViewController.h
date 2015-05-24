//
//  AVHFlightInfoViewController.h
//  AVH
//
//  Created by Anamika on 5/13/15.
//  Copyright (c) 2015 Sreelal H. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AVHFlightInfoViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    IBOutlet UITableView *flightTableView;
    IBOutlet UISegmentedControl *segmentControl;
}

@end
