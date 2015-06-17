//
//  AVHTripAdvisorViewController.h
//  AVH
//
//  Created by Sreelash S on 17/06/15.
//  Copyright (c) 2015 Sreelal H. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AVHTripAdvisorViewController : UIViewController {
    IBOutlet UITableView *infoTableView;
}

@property (nonatomic, assign) BOOL isFromMenu;

@end
