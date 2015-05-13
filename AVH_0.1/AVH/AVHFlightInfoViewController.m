//
//  AVHFlightInfoViewController.m
//  AVH
//
//  Created by Anamika on 5/13/15.
//  Copyright (c) 2015 Sreelal H. All rights reserved.
//

#import "AVHFlightInfoViewController.h"
#import "WebHandler.h"
#import "FlightInfoTableViewCell.h"
#import "AppDelegate.h"

@interface AVHFlightInfoViewController ()

@property (nonatomic, strong) NSMutableArray *flightStatuses;

@end

@implementation AVHFlightInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    
    [[AppDelegate instance] showBusyView:@"Loading Flight Info ..."];
    
    [WebHandler getFlightDepInfoWithCallback:^(id object, NSError *error) {
        
            dispatch_async(dispatch_get_main_queue(), ^{
                if (object) {
                    _flightStatuses = object[@"flightStatuses"];
                    [flightTableView reloadData];
                }
                [[AppDelegate instance] hideBusyView];
            });
        
        NSLog(@"%ld", _flightStatuses.count);
    }];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TableView Delegates

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _flightStatuses.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *flightInfo = _flightStatuses[indexPath.row];
    
    FlightInfoTableViewCell *flightInfoCell = [tableView dequeueReusableCellWithIdentifier:@"flightCell"];
    flightInfoCell.flighNumberLbl.text = flightInfo[@"flightNumber"];
    flightInfoCell.flightStatusLbl.text = flightInfo[@"status"];
    flightInfoCell.flightNameLbl.text = flightInfo[@"carrierFsCode"];
    flightInfoCell.arrivalLbl.text = flightInfo[@"arrivalDate"][@"dateLocal"];
    flightInfoCell.departureLbl.text = flightInfo[@"departureDate"][@"dateLocal"];

    
    return flightInfoCell;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
