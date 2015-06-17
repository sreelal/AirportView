//
//  AVHTripAdvisorViewController.m
//  AVH
//
//  Created by Sreelash S on 17/06/15.
//  Copyright (c) 2015 Sreelal H. All rights reserved.
//

#import "AVHTripAdvisorViewController.h"
#import "HelperClass.h"
#import "AppDelegate.h"
#import "WebHandler.h"
#import "TripAdvisorCell.h"

@interface AVHTripAdvisorViewController ()

@property (nonatomic, assign) BOOL isViewPopped;

@property (nonatomic, strong) NSMutableArray *reviews;


@end

@implementation AVHTripAdvisorViewController
@synthesize isFromMenu;

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"AVH_logo.png"]];
    
    UIBarButtonItem *leftBarItem = [HelperClass getBackButtonItemWithTarget:self andAction:@selector(navgationBackClicked:)];
    leftBarItem.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = leftBarItem;
    
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    
    [[AppDelegate instance] showBusyView:@"Loading Reviews..."];
    
    [WebHandler getTripAdvisorReviewswithCallback:^(id object, NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (object) {
                _reviews = object[@"reviews"];
                [infoTableView reloadData];
            }
            
            [[AppDelegate instance] hideBusyView];
        });
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

#pragma mark - TableView Delegates & Datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _reviews.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *infoDict = _reviews[indexPath.row];
    NSString *ratingImgUrl = infoDict[@"rating_image_url"];
    
    static NSString *cellId = @"TripAdvisorCell";
    TripAdvisorCell *tripAdvisorCell = (TripAdvisorCell *)[tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
    tripAdvisorCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    tripAdvisorCell.titleLbl.text = [NSString stringWithFormat:@"\"%@\"", infoDict[@"title"]];
    tripAdvisorCell.reviewLbl.text = infoDict[@"text"];
    tripAdvisorCell.nameLbt.text = infoDict[@"user"][@"username"];
    tripAdvisorCell.stayLbl.text = [NSString stringWithFormat:@"%@, %@", infoDict[@"travel_date"], infoDict[@"trip_type"]];
    
    [tripAdvisorCell loadReviewImageWithURL:ratingImgUrl];
    
    //hotelInfoCell.title.text = infoDict[@"title"];
    
    //NSArray *images = infoDict[@"images"];
    
    //[hotelInfoCell loadInfoImageWithURL:[images firstObject]];
    
    return tripAdvisorCell;
}

@end
