//
//  AVHOfferInfoViewController.m
//  AVH
//
//  Created by Sreelash S on 31/05/15.
//  Copyright (c) 2015 Sreelal H. All rights reserved.
//

#import "AVHOfferInfoListViewController.h"
#import "AVHOfferInfoDetailViewController.h"

#import "HelperClass.h"
#import "AppDelegate.h"
#import "WebHandler.h"
#import "AVHOfferCell.h"

@interface AVHOfferInfoListViewController ()

@property (nonatomic, assign) BOOL isViewPopped;

@property (nonatomic, strong) NSMutableArray *offers;

@end

@implementation AVHOfferInfoListViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];

    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"AVH_logo.png"]];
    
    UIBarButtonItem *leftBarItem = [HelperClass getBackButtonItemWithTarget:self andAction:@selector(navgationBackClicked:)];
    leftBarItem.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = leftBarItem;
    
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    
    [[AppDelegate instance] showBusyView:@"Loading Offers..."];
    
    [WebHandler getOfferInfoListWithCallback:^(id object, NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (object) {
                _offers = object;
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
    
    if (_isFromMenu) {
        [self.sideMenuViewController setContentViewController:[AppDelegate instance].homeVC];
        [self.sideMenuViewController hideMenuViewController];
    }
    else {
        _isViewPopped = YES;
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - TableView Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _offers.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *offerDict = _offers[indexPath.row];
    
    static NSString *cellId = @"offerInfoCell";
    AVHOfferCell *offerCell = (AVHOfferCell *)[tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
    offerCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    offerCell.offerTitle.text = offerDict[@"title"];
    offerCell.offerMessage.text = offerDict[@"message"];
    
    NSArray *validity = [offerDict[@"valid_till"] componentsSeparatedByString:@"T"];
    
    offerCell.offerValidity.text = [NSString stringWithFormat:@"Offer Valid Till %@", [validity firstObject]];
    
    NSString *imageURL = [NSString stringWithFormat:@"%@img/%@", SERVICE_URL_ROOT, offerDict[@"image"]];
    
    [offerCell loadInfoImageWithURL:imageURL];
    
    return offerCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *infoDict = _offers[indexPath.row];
    
    AVHOfferInfoDetailViewController *offerInfoDetailsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"OfferInfoDetailVC"];
    offerInfoDetailsVC.offerDetails = infoDict;
    
    [self.navigationController pushViewController:offerInfoDetailsVC animated:YES];
}


@end
