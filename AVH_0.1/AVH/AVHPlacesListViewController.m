//
//  AVHPlacesListViewController.m
//  AVH
//
//  Created by Sreelash S on 03/06/15.
//  Copyright (c) 2015 Sreelal H. All rights reserved.
//

#import "AVHPlacesListViewController.h"
#import "HelperClass.h"
#import "AppDelegate.h"
#import "WebHandler.h"
#import "AVHHotelInfoListCell.h"
#import "AVHPlaceInfoViewController.h"

@interface AVHPlacesListViewController ()

@property (nonatomic, assign) BOOL isViewPopped;

@property (nonatomic, strong) NSMutableArray *places;

@end

@implementation AVHPlacesListViewController
@synthesize isFromMenu;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"AVH_logo.png"]];
    
    UIBarButtonItem *leftBarItem = [HelperClass getBackButtonItemWithTarget:self andAction:@selector(navgationBackClicked:)];
    leftBarItem.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = leftBarItem;
    
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    
    [[AppDelegate instance] showBusyView:@"Loading Places To Visit..."];
    
    [WebHandler getPlacesToVisitWithCallback:^(id object, NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (object) {
                _places = object;
                [infoTableView reloadData];
            }
            
            [[AppDelegate instance] hideBusyView];
        });
    }];
}

#pragma mark - Button Actions

- (void)navgationBackClicked:(id)sender {
    
    if (isFromMenu) {
        [self.sideMenuViewController setContentViewController:[AppDelegate instance].homeVC];
        [self.sideMenuViewController hideMenuViewController];
    }
    else {
        _isViewPopped = YES;
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TableView Delegates & Datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _places.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *infoDict = _places[indexPath.row];
    
    static NSString *cellId = @"hotelInfoCell";
    AVHHotelInfoListCell *hotelInfoCell = (AVHHotelInfoListCell *)[tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
    hotelInfoCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    hotelInfoCell.title.text = infoDict[@"title"];
    
    NSArray *images = infoDict[@"images"];
    
    [hotelInfoCell loadInfoImageWithURL:[images firstObject]];
    
    return hotelInfoCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *infoDict = _places[indexPath.row];
    
    AVHPlaceInfoViewController *hotelInfoDetailsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"PlaceInfoVC"];
    hotelInfoDetailsVC.placeDetails = infoDict;
    
    [self.navigationController pushViewController:hotelInfoDetailsVC animated:YES];
}
@end
