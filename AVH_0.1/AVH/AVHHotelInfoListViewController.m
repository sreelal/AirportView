//
//  AVHHotelInfoViewController.m
//  AVH
//
//  Created by Sreelash S on 30/05/15.
//  Copyright (c) 2015 Sreelal H. All rights reserved.
//

#import "AVHHotelInfoListViewController.h"
#import "AVHHotelInfoListCell.h"
#import "AVHHotelInfoDetailViewController.h"
#import "HelperClass.h"
#import "WebHandler.h"
#import "AppDelegate.h"

@interface AVHHotelInfoListViewController ()

@property (nonatomic, assign) BOOL isViewPopped;

@property (nonatomic, strong) NSMutableArray *hotelInfos;

@end

@implementation AVHHotelInfoListViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"AVH_logo.png"]];
    
    UIBarButtonItem *leftBarItem = [HelperClass getBackButtonItemWithTarget:self andAction:@selector(navgationBackClicked:)];
    leftBarItem.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = leftBarItem;
    
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    
    [[AppDelegate instance] showBusyView:@"Loading Hotel Info..."];
    
    [WebHandler getHotelInfoListWithCallback:^(id object, NSError *error) {
        
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if (object) {
                    _hotelInfos = object;
                    [infoTableView reloadData];
                }
                
                [[AppDelegate instance] hideBusyView];
            });
    }];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    if (_isViewPopped)
        [[self navigationController] setNavigationBarHidden:YES animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Button Actions

- (void)navgationBackClicked:(id)sender {
    
    _isViewPopped = YES;
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - TableView Delegates & Datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _hotelInfos.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *infoDict = _hotelInfos[indexPath.row];
    
    static NSString *cellId = @"hotelInfoCell";
    AVHHotelInfoListCell *hotelInfoCell = (AVHHotelInfoListCell *)[tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
    hotelInfoCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    hotelInfoCell.title.text = infoDict[@"title"];
    
    NSArray *images = infoDict[@"images"];
    
    [hotelInfoCell loadInfoImageWithURL:[images firstObject]];
    
    return hotelInfoCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *infoDict = _hotelInfos[indexPath.row];
    
    AVHHotelInfoDetailViewController *hotelInfoDetailsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"HotelInfoDetailVC"];
    hotelInfoDetailsVC.hotelDetails = infoDict;
    
    [self.navigationController pushViewController:hotelInfoDetailsVC animated:YES];
}

@end
