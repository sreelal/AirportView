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
#import "AVHContactUsViewController.h"
#import "AVHFaceBookViewController.h"
#import "AVHTripAdvisorViewController.h"

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
    
    self.menus = [[NSMutableArray alloc] initWithObjects:@"Home", @"Booking", @"Hotel Info", @"Offers", @"Gallery", @"Places To Visit", @"Weather", @"Trip Advisor", @"Facebook", @"Contact", @"Call", nil];
    
    self.menuTableView.delegate = self;
    self.menuTableView.dataSource = self;
    self.menuTableView.backgroundColor = [UIColor clearColor];
    
    self.menuTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshMenuCategories:) name:NOTIFICATION_REFRESH_MENU object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    [menuTableView reloadData];
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
        
    switch (indexPath.row) {
        case 0: {
            AVHHomeViewController *homeVC = [self.storyboard instantiateViewControllerWithIdentifier:@"homeviewController"];
            [self.sideMenuViewController setContentViewController:homeVC];
            [self.sideMenuViewController hideMenuViewController];
        }
        break;
        case 1: {
            UINavigationController *yourStayNavVC = [self.storyboard instantiateViewControllerWithIdentifier:@"yourStayNavigation"];
            AVHYourStayViewController *yourStayVC = [yourStayNavVC.viewControllers firstObject];
            yourStayVC.isFromMenu = YES;
            
            [self.sideMenuViewController setContentViewController:yourStayNavVC];
            [self.sideMenuViewController hideMenuViewController];
        }
        break;
        case 2: {
            UINavigationController *hotelInfoNavVC = [self.storyboard instantiateViewControllerWithIdentifier:@"hotelInfoNav"];
            AVHHotelInfoListViewController *hotelInfoVC = [hotelInfoNavVC.viewControllers firstObject];
            hotelInfoVC.isFromMenu = YES;
            
            [self.sideMenuViewController setContentViewController:hotelInfoNavVC];
            [self.sideMenuViewController hideMenuViewController];
        }
        break;
        case 3: {
            UINavigationController *offerNavVC = [self.storyboard instantiateViewControllerWithIdentifier:@"OfferNav"];
            AVHOfferInfoListViewController *offerInfoVC = [offerNavVC.viewControllers firstObject];
            offerInfoVC.isFromMenu = YES;
            
            [self.sideMenuViewController setContentViewController:offerNavVC];
            [self.sideMenuViewController hideMenuViewController];
        }
            break;
        case 4: {
            UINavigationController *galleryNavVC = [self.storyboard instantiateViewControllerWithIdentifier:@"GalleryNav"];
            AVHGalleryListViewController *galleryVC = [galleryNavVC.viewControllers firstObject];
            galleryVC.isFromMenu = YES;
            
            [self.sideMenuViewController setContentViewController:galleryNavVC];
            [self.sideMenuViewController hideMenuViewController];
        }
            break;
        case 5: {
            UINavigationController *placesNavVC = [self.storyboard instantiateViewControllerWithIdentifier:@"PlacesNav"];
            AVHPlacesListViewController *placesListVC = [placesNavVC.viewControllers firstObject];
            placesListVC.isFromMenu = YES;
            
            [self.sideMenuViewController setContentViewController:placesNavVC];
            [self.sideMenuViewController hideMenuViewController];
        }
        break;
        case 6: {
            UINavigationController *weatherNavVC = [self.storyboard instantiateViewControllerWithIdentifier:@"WeatherNav"];
            AVHWeatherViewController *weatherVC= [weatherNavVC.viewControllers firstObject];
            weatherVC.isFromMenu = YES;
            
            [self.sideMenuViewController setContentViewController:weatherNavVC];
            [self.sideMenuViewController hideMenuViewController];
        }
        break;
        case 7: {
            UINavigationController *taNavVC = [self.storyboard instantiateViewControllerWithIdentifier:@"TripAdvisorNav"];
            AVHTripAdvisorViewController *taVC= [taNavVC.viewControllers firstObject];
            taVC.isFromMenu = YES;
            
            [self.sideMenuViewController setContentViewController:taNavVC];
            [self.sideMenuViewController hideMenuViewController];
        }
            break;
        case 8: {
            UINavigationController *fbNavVC = [self.storyboard instantiateViewControllerWithIdentifier:@"fbNav"];
            AVHFaceBookViewController *fbVC= [fbNavVC.viewControllers firstObject];
            fbVC.isFromMenu = YES;
            
            [self.sideMenuViewController setContentViewController:fbNavVC];
            [self.sideMenuViewController hideMenuViewController];
        }
            break;
        case 9: {
            UINavigationController *contactNavVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ContactNav"];
            AVHContactUsViewController *contactVC= [contactNavVC.viewControllers firstObject];
            contactVC.isFromMenu = YES;
            
            [self.sideMenuViewController setContentViewController:contactNavVC];
            [self.sideMenuViewController hideMenuViewController];
        }
        break;
        case 10: {
            //NSString *phNo = @"+919876543210";
            //NSURL *phoneUrl = [NSURL URLWithString:[NSString  stringWithFormat:@"telprompt:%@",phNo]];
            //NSURL *url = [NSURL URLWithString:@"telprompt://030-7070-701"];
            //[[UIApplication  sharedApplication] openURL:url];
            NSURL *phoneUrl = [NSURL URLWithString:@"telprompt://+233-020-2252-244"];
            //NSURL *phoneUrl = [NSURL URLWithString:@"tel://+233 0202252244"];
            
            //[[UIApplication sharedApplication] openURL:phoneUrl];
            
            if ([[UIApplication sharedApplication] canOpenURL:phoneUrl]) {
                [[UIApplication sharedApplication] openURL:phoneUrl];
            } else
            {
                UIAlertView *calert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Call facility is not available!!!" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
                [calert show];
            }
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
        menuCell.menuIconImgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"menu_%ld.png", (long)indexPath.row]];
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
