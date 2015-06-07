//
//  DGHMenuViewController.m
//  DeviceGH
//
//  Created by Sreelal H on 07/12/14.
//  Copyright (c) 2014 Sreelal H. All rights reserved.
//

#import "AVHMenuViewController.h"
#import "UIViewController+RESideMenu.h"
#import "AVHYourStayViewController.h"
#import "AVHHotelInfoListViewController.h"
#import "AVHOfferInfoListViewController.h"
#import "AVHGalleryListViewController.h"
#import "AVHPlacesListViewController.h"

#import "ProductCategory.h"
#import "Constants.h"
#import "AppDelegate.h"

#import "HelperClass.h"
#import "UtilClass.h"
#import "MenuHeaderCell.h"
#import "SubMenuCell.h"

@interface AVHMenuViewController ()<DGHContentViewControllerDelegate>

@property (nonatomic, strong) NSMutableArray *menus;
@property (nonatomic, strong) NSMutableArray *promotionMenus;

@end

@implementation AVHMenuViewController
@synthesize menuTableView;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    //Manages menu table right alignment
    if ([HelperClass isIphone6Plus])
        dummyViewWidthPin.constant = 177;
    else if ([HelperClass isIphone6])
        dummyViewWidthPin.constant = 158;
    else
        dummyViewWidthPin.constant = 130;
    
    [self.view layoutIfNeeded];
    /////////////////////////////////////
    
    //self.view.backgroundColor = [UIColor colorWithPatternImage: [UIImage imageNamed: @"NavigationBg.png"]];
    
    self.menus = [[NSMutableArray alloc] initWithObjects:@"Home", @"Booking", @"Hotel Info", @"Contact", @"Offers", @"Gallery", @"Places To Visit", @"Weather", @"Trip Advisor", @"Facebook", nil];
    
    self.menuTableView.delegate = self;
    self.menuTableView.dataSource = self;
    self.menuTableView.backgroundColor = [UIColor clearColor];
    
    self.menuTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshMenuCategories:) name:NOTIFICATION_REFRESH_MENU object:nil];
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}

#pragma mark - Helper Methods
- (void)refreshMenuCategories:(NSNotification *)notification {
    
    if (notification.object != nil) {
        self.menuCategories = notification.object;
        [self.menuTableView reloadData];
    }
}

#pragma mark -
#pragma mark UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [[UtilClass sharedManager] setActiveMenuIndex:indexPath.row];
    
    [self.menuTableView reloadData];
    
    //[tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.section) {
        case 0: {
            [self.sideMenuViewController setContentViewController:[AppDelegate instance].homeVC];
            [self.sideMenuViewController hideMenuViewController];
        }
        break;
        case 1: {
            AVHYourStayViewController *yourStayVC = [self.storyboard instantiateViewControllerWithIdentifier:@"YourStayVC"];
            [self.sideMenuViewController setContentViewController:yourStayVC];
            [self.sideMenuViewController hideMenuViewController];
        }
        break;
        case 2: {
            AVHHotelInfoListViewController *hotelInfoListVC = [self.storyboard instantiateViewControllerWithIdentifier:@"HotelInfoListVC"];
            
            [self.sideMenuViewController setContentViewController:hotelInfoListVC];
            [self.sideMenuViewController hideMenuViewController];
        }
        break;
        case 3: {
            AVHOfferInfoListViewController *offerInfoVC = [self.storyboard instantiateViewControllerWithIdentifier:@"OfferListVC"];
            
            [self.sideMenuViewController setContentViewController:offerInfoVC];
            [self.sideMenuViewController hideMenuViewController];
        }
            break;
        case 4: {
            AVHGalleryListViewController *galleryVC = [self.storyboard instantiateViewControllerWithIdentifier:@"GalleryVC"];
            
            [self.sideMenuViewController setContentViewController:galleryVC];
            [self.sideMenuViewController hideMenuViewController];
        }
        break;
        case 5: {
            AVHPlacesListViewController *placesListVC = [self.storyboard instantiateViewControllerWithIdentifier:@"PlacesListVC"];
            
            [self.sideMenuViewController setContentViewController:placesListVC];
            [self.sideMenuViewController hideMenuViewController];
        }
        break;
        case 6: {
            AVHWeatherViewController *weatherVC = [self.storyboard instantiateViewControllerWithIdentifier:@"WeatherVC"];
            
            [self.sideMenuViewController setContentViewController:weatherVC];
            [self.sideMenuViewController hideMenuViewController];
        }
        break;
        default: {
            [self.sideMenuViewController hideMenuViewController];
        }
        break;
    }
}

#pragma mark -
#pragma mark UITableView Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex {
    
    return self.menus.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MenuHeaderCell *menuCell = (MenuHeaderCell *)[tableView dequeueReusableCellWithIdentifier:CELL_ID_MENU_HEADER forIndexPath:indexPath];
    
    menuCell.backgroundColor = [UIColor clearColor];
    menuCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if ([[UtilClass sharedManager] getActiveMenuIndex] == indexPath.row) {
        menuCell.contentView.backgroundColor = [UIColor lightGrayColor];
        //menuCell.menuIconImgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"menu_%ld_selected.png", indexPath.row]];
        menuCell.menuHeaderLabel.textColor = [UIColor darkGrayColor];
    }
    else {
        menuCell.contentView.backgroundColor = [UIColor clearColor];
        menuCell.menuIconImgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"menu_%ld.png", (long)indexPath.row]];
        menuCell.menuHeaderLabel.textColor = [UIColor lightGrayColor];
    }
    
    NSString  *sectionHeaderTitle  = [self.menus objectAtIndex:indexPath.row];
    
    menuCell.menuHeaderLabel.text  = sectionHeaderTitle;
    
    return menuCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 40.0f;
}

#pragma mark -
#pragma mark DGHContentViewControllerDelegate methods

- (void)onGoToHomeScreen {
    
    [self.sideMenuViewController setContentViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"homeviewController"]
                                                 animated:YES];
}

@end
