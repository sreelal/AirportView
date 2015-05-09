//
//  DGHMenuViewController.m
//  DeviceGH
//
//  Created by Sreelal H on 07/12/14.
//  Copyright (c) 2014 Sreelal H. All rights reserved.
//

#import "DGHMenuViewController.h"
#import "UIViewController+RESideMenu.h"
#import "DGHContentViewController.h"
#import "DGHProductViewController.h"
#import "ProductCategory.h"
#import "Constants.h"
#import "AppDelegate.h"
#import "DGHEnquireViewController.h"
#import "DGhNotificationViewController.h"
#import "DGHWebViewController.h"

#import "MenuHeaderCell.h"
#import "SubMenuCell.h"

@interface DGHMenuViewController ()<DGHContentViewControllerDelegate>

@property (nonatomic, strong) NSMutableArray *menus;
@property (nonatomic, strong) NSMutableArray *promotionMenus;

@end

@implementation DGHMenuViewController
@synthesize menuTableView;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage: [UIImage imageNamed: @"NavigationBg.png"]];
    
    self.menus = [[NSMutableArray alloc] initWithObjects:@"Home", @"All Categories", @"Enquiry List", @"Promotions", @"About Us", @"Contact Us", @"Notifications", nil];
    self.promotionMenus = [[NSMutableArray alloc] initWithObjects:@"Weekly Promoions", @"Monthly Promotions", nil];
    
    self.menuTableView.delegate = self;
    self.menuTableView.dataSource = self;
    
    self.menuTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.menuTableView setBackgroundColor:[UIColor clearColor]];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"row_bg.jpg"]];
    [self.menuTableView setBackgroundView:imageView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshMenuCategories:) name:NOTIFICATION_REFRESH_MENU object:nil];
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

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
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.section) {
        case 0: {
            [self.sideMenuViewController setContentViewController:[AppDelegate instance].homeVC];
            [self.sideMenuViewController hideMenuViewController];
        }
        break;
        case 1: {
            UINavigationController *navController;
            
            ProductCategory *selectedCategory = self.menuCategories[indexPath.row];
            
            if (selectedCategory.children > 0) {
                UINavigationController *categoryVCNav = [self.storyboard instantiateViewControllerWithIdentifier:@"ContentViewNavigation"];
                DGHContentViewController *contentView = [[categoryVCNav viewControllers] firstObject];
                
                contentView.category = selectedCategory;
                navController = categoryVCNav;
            }
            else if (selectedCategory.children == 0) {
                UINavigationController *productVCNav = [self.storyboard instantiateViewControllerWithIdentifier:@"ProductViewNavigation"];
                DGHProductViewController *productView = [[productVCNav viewControllers] firstObject];
                
                productView.category = selectedCategory;
                navController = productVCNav;
            }
            
            [self.sideMenuViewController setContentViewController:navController];
            [self.sideMenuViewController hideMenuViewController];
        }
        break;
        case 2: {
            UINavigationController *enquireVCNav = [self.storyboard instantiateViewControllerWithIdentifier:@"EnquireViewNavigation"];
            
            [self.sideMenuViewController setContentViewController:enquireVCNav];
            [self.sideMenuViewController hideMenuViewController];
        }
        break;
        case 3: {
            UINavigationController *webViewVCNav = [self.storyboard instantiateViewControllerWithIdentifier:@"WebViewNavigation"];
            DGHWebViewController *webView = [[webViewVCNav viewControllers] firstObject];
            
            if (indexPath.row == 0) webView.viewTitle = VIEW_TITLE_WEEKLY;
            else if (indexPath.row == 1) webView.viewTitle = VIEW_TITLE_MONTHLY;
            
            [self.sideMenuViewController setContentViewController:webViewVCNav];
            [self.sideMenuViewController hideMenuViewController];
        }
            break;
        case 4: {
            UINavigationController *webViewVCNav = [self.storyboard instantiateViewControllerWithIdentifier:@"WebViewNavigation"];
            DGHWebViewController *webView = [[webViewVCNav viewControllers] firstObject];
            webView.viewTitle = VIEW_TITLE_ABOUT;
            //webView.title = VIEW_TITLE_ABOUT;
            
            [self.sideMenuViewController setContentViewController:webViewVCNav];
            [self.sideMenuViewController hideMenuViewController];
        }
        break;
        case 5: {
            UINavigationController *enquireVCNav = [self.storyboard instantiateViewControllerWithIdentifier:@"EnquireViewNavigation"];
            DGHEnquireViewController *enquireView = [[enquireVCNav viewControllers] firstObject];
            enquireView.isFromMenu = YES;
            
            [self.sideMenuViewController setContentViewController:enquireVCNav];
            [self.sideMenuViewController hideMenuViewController];
        }
        break;
        case 6: {
            UINavigationController *notificationVCNav = [self.storyboard instantiateViewControllerWithIdentifier:@"NotificationViewNavigation"];
            
            [self.sideMenuViewController setContentViewController:notificationVCNav];
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
    
    //return 1;
    return self.menus.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex {
    
    NSInteger rows = 1;
    
    if (sectionIndex == 1) rows = _menuCategories.count;
    else if (sectionIndex == 3) rows = _promotionMenus.count;
    
    return rows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell;
    
    if (indexPath.section == 1 || indexPath.section == 3) {
        SubMenuCell *subMenuCell = (SubMenuCell *)[tableView dequeueReusableCellWithIdentifier:CELL_ID_SUB_MENU forIndexPath:indexPath];
        
        switch (indexPath.section) {
            case 1:{
                ProductCategory *category = _menuCategories[indexPath.row];
                subMenuCell.subMenuLabel.text = category.name;
                break;
            }
            case 3:{
                NSString *promotionSubMenu = _promotionMenus[indexPath.row];
                subMenuCell.subMenuLabel.text = promotionSubMenu;
                break;
            }
            default:
                break;
        }
        
        cell = subMenuCell;
    }
    else {
        MenuHeaderCell *menuCell = (MenuHeaderCell *)[tableView dequeueReusableCellWithIdentifier:CELL_ID_MENU_HEADER forIndexPath:indexPath];
        
        NSString  *sectionHeaderTitle     = [self.menus objectAtIndex:indexPath.section];
        
        menuCell.menuHeaderLabel.text = sectionHeaderTitle;
        
        cell = menuCell;
    }
    
    return cell;
    
    /*static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:18];
        cell.textLabel.textColor = [UIColor blackColor];
        cell.textLabel.highlightedTextColor = [UIColor lightGrayColor];
        cell.selectedBackgroundView = [[UIView alloc] init];
    }
    
    ProductCategory *category = _menuCategories[indexPath.row];
    
    cell.textLabel.text = category.name;
    
    return cell;*/
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *headerView = nil;
    
    if (section == 1 || section == 3) {
        static NSString *CellIdentifier = CELL_ID_MENU_HEADER;
        UITableViewCell *sectionHeaderView = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        while (sectionHeaderView.contentView.gestureRecognizers.count) {
            [sectionHeaderView.contentView removeGestureRecognizer:[sectionHeaderView.contentView.gestureRecognizers objectAtIndex:0]];
        }
        
        headerView = sectionHeaderView.contentView;
        
        NSInteger sectionHeaderTitleIndex = section;
        NSString  *sectionHeaderTitle     = [self.menus objectAtIndex:sectionHeaderTitleIndex];
        
        UILabel *menuHeaderLabel = (UILabel *)[headerView viewWithTag:111];
        
        menuHeaderLabel.text = sectionHeaderTitle;
    }
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 40.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    CGFloat height = 0;
    
    if (section == 1 || section == 3) height = 40;
    
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0;
}

#pragma mark -
#pragma mark DGHContentViewControllerDelegate methods

- (void)onGoToHomeScreen {
    
    [self.sideMenuViewController setContentViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"homeviewController"]
                                                 animated:YES];
}

@end
