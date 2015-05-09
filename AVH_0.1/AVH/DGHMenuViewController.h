//
//  DGHMenuViewController.h
//  DeviceGH
//
//  Created by Sreelal H on 07/12/14.
//  Copyright (c) 2014 Sreelal H. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RESideMenu.h"

@interface DGHMenuViewController : UIViewController<RESideMenuDelegate, UITableViewDelegate, UITableViewDataSource> {
    
}

@property (nonatomic, strong) IBOutlet UITableView *menuTableView;
@property (nonatomic, strong) NSMutableArray *menuCategories;

@end
