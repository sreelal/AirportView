//
//  DGHHomeViewController.m
//  DeviceGH
//
//  Created by Sreelal H on 07/12/14.
//  Copyright (c) 2014 Sreelal H. All rights reserved.
//

#import "AVHHomeViewController.h"
//#import "AOScrollerView.h"
#import "WebHandler.h"
#import "Constants.h"
#import "ProductCategory.h"
#import "Banner.h"
#import "AppDelegate.h"
#import "HelperClass.h"
#import "CacheManager.h"
#import "DGHHomeCollectionViewCell.h"
#import "DGHProductViewController.h"
#import "DGHEnquireViewController.h"
#import "AVHBookingViewController.h"
#import "AVHRoomsRatesViewController.h"
#import "AVHYourStayViewController.h"
#import "AVHDirectionsViewController.h"
#import "AVHHotelInfoListViewController.h"
#import "AVHOfferInfoListViewController.h"
#import "AVHPlacesListViewController.h"
#import "AVHGalleryListViewController.h"
#import "AVHContactUsViewController.h"
#import "UtilClass.h"

#import <QuartzCore/QuartzCore.h>

@interface AVHHomeViewController ()<RESideMenuDelegate>{
   

}

@property (strong, nonatomic) NSMutableArray  *menuItems;
@property (strong, nonatomic) NSMutableArray  *searchProducts;

@end

@implementation AVHHomeViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    
    [categoiesCollectionView setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    
    self.menuItems = [[NSMutableArray alloc] initWithObjects:@"BOOKING", @"HOTEL INFO", @"CONTACT", @"OFFERS", @"GALLERY", @"PLACES TO VISIT", @"WEATHER", nil];
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    [categoiesCollectionView reloadData];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [[self navigationController] setNavigationBarHidden:YES animated:YES];

    //[self loadCategories];
    //[self loadBannerImages];
    //[self loadFooterText];
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Webservice Implementations

- (void)loadCategories {
    
    [[AppDelegate instance] showBusyView:@"Loading..."];
    
    [WebHandler getCategoriesWithCallback:^(id object, NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSMutableArray *categories = self.homeCategories = (NSMutableArray *)object;
            
            if (categories.count) {                
                [categoiesCollectionView reloadData];
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_REFRESH_MENU object:categories];
            }
            
            [[AppDelegate instance] hideBusyView];
        });
    }];
}

- (void)loadBannerImages {
    
    [WebHandler getBannerImagesWithCallback:^(id object, NSError *error) {
        
        NSMutableArray *banners      = (NSMutableArray *)object;
        
        if (banners.count) {
            NSMutableArray *bannerImages = [[NSMutableArray alloc] init];
            
            [banners enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                Banner *banner = (Banner *)obj;
                [bannerImages addObject:banner.bannerImageUrl];
            }];
            
            NSLog(@"Bnner Images : %@", bannerImages);
            
            if (bannerImages.count) {                
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIView *removingView = [self.view viewWithTag:222];
                    [removingView removeFromSuperview];
                    
                    /*AOScrollerView *aSV = [[AOScrollerView alloc]initWithNameArr:bannerImages titleArr:nil height:120
                                                                           width: self.view.frame.size.width];
                    aSV.vDelegate=self;
                    aSV.frame = CGRectMake(0, 110, self.view.frame.size.width, 120);
                    aSV.tag = 222;
                    
                    [self.view addSubview:aSV];*/
                });
            }            
        }
    }];
}

- (void)loadFooterText {
    
    [WebHandler getFooterTextWithCallback:^(id object, NSError *error) {
        if (object != nil) [[CacheManager sharedInstance] saveFooterText:object];
        else object = [[CacheManager sharedInstance] footerText];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (object != nil) [self startMarqueeScrollingWithText:object];
        });
    }];
}

#pragma mark - AOScrollViewDelegate

- (void)buttonClick:(int)vid {
    
    NSLog(@"%d",vid);
}

#pragma mark - Button Actions

- (IBAction)locationBtnAction:(id)sender {
    
    AVHDirectionsViewController *directionsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"DirectionsVC"];
    [self.navigationController pushViewController:directionsVC animated:YES];
}

- (IBAction)menuBtnAction:(id)sender {
    
    
}

#pragma mark - Marquee Scrolling Label

- (void)startMarqueeScrollingWithText:(NSString *)text {
    
    self.footerLabel.text = [NSString stringWithFormat:@"%@    %@", text, text];
    //self.footerLabel.text =  @"This is a test of MarqueeLabel - the text is long enough that it needs to scroll to see the whole thing.";
    self.footerLabel.rate = 16.0;
    self.footerLabel.fadeLength = 10.0;
    self.footerLabel.marqueeType = MLContinuous;
    //self.footerLabel.continuousMarqueeExtraBuffer = 10.0f;
    self.footerLabel.animationDelay = 3;
    
    //[self.footerLabel restartLabel];
    
    /*self.footerLabel.marqueeType = MLContinuous;
    self.footerLabel.scrollDuration = 15.0;
    self.footerLabel.animationCurve = UIViewAnimationOptionCurveEaseInOut;
    self.footerLabel.fadeLength = 10.0f;
    self.footerLabel.leadingBuffer = 30.0f;
    self.footerLabel.trailingBuffer = 20.0f;
    self.footerLabel.tag = 101;
    self.footerLabel.text = @"This is a test of MarqueeLabel - the text is long enough that it needs to scroll to see the whole thing.";*/
    
    //[MarqueeLabel controllerViewWillAppear:self];
}

#pragma mark - UICollectionView Delegates

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {

    return self.menuItems.count;
}

- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    DGHHomeCollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"HomeCell" forIndexPath:indexPath];
    
    cell.iconImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"menu_%ld_icon", (long)indexPath.row]];
    cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"menu_%ld_bg", (long)indexPath.row]];
    cell.titleLabel.text = self.menuItems[indexPath.row];
    //[cell setupBg];
    //[cell loadCategoryImageForCategory:category];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.row) {
        case 0:{
            [[UtilClass sharedManager] setActiveMenuIndex:1];
            
            AVHYourStayViewController *yourStayVC = [self.storyboard instantiateViewControllerWithIdentifier:@"YourStayVC"];
            [self.navigationController pushViewController:yourStayVC animated:YES];
        }
        break;
         
        case 1:{
            [[UtilClass sharedManager] setActiveMenuIndex:2];
            
            AVHHotelInfoListViewController *hotelInfoListVC = [self.storyboard instantiateViewControllerWithIdentifier:@"HotelInfoListVC"];
            [self.navigationController pushViewController:hotelInfoListVC animated:YES];
        }
        break;
            
        case 2:{
            [[UtilClass sharedManager] setActiveMenuIndex:9];
            
            AVHContactUsViewController *contactUsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ContactVC"];
            [self.navigationController pushViewController:contactUsVC animated:YES];
        }
            break;
            
        case 3:{
            [[UtilClass sharedManager] setActiveMenuIndex:3];
            
            AVHOfferInfoListViewController *offerInfoVC = [self.storyboard instantiateViewControllerWithIdentifier:@"OfferListVC"];
            [self.navigationController pushViewController:offerInfoVC animated:YES];
        }
        break;
            
        case 4:{
            [[UtilClass sharedManager] setActiveMenuIndex:4];
            
            AVHGalleryListViewController *galleryVC = [self.storyboard instantiateViewControllerWithIdentifier:@"GalleryVC"];
            [self.navigationController pushViewController:galleryVC animated:YES];
        }
        break;
            
        case 5:{
            [[UtilClass sharedManager] setActiveMenuIndex:5];
            
            AVHPlacesListViewController *placesListVC = [self.storyboard instantiateViewControllerWithIdentifier:@"PlacesListVC"];
            [self.navigationController pushViewController:placesListVC animated:YES];
        }
        break;

        case 6:{
            [[UtilClass sharedManager] setActiveMenuIndex:6];
            
            AVHWeatherViewController *weatherVC = [self.storyboard instantiateViewControllerWithIdentifier:@"WeatherVC"];
            [self.navigationController pushViewController:weatherVC animated:YES];
        }
        break;
            
        case 7:{
            
        }
        break;
    
        
            
           // DirectionsVC
            
        default:
        break;
    }
    
    //[self performSegueWithIdentifier:@"weatherSeague" sender:self];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat pixel = [UIScreen mainScreen].bounds.size.width / 2 - 10;
    CGSize size;
    
    /*if ([HelperClass isIphone6Plus]) pixel = 135;
    else if ([HelperClass isIphone6]) pixel = 125;
    else pixel = 105;*/
    
    size = CGSizeMake(pixel, pixel);
    
    return size;
}

- (UIEdgeInsets)collectionView:
(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    UIEdgeInsets insets = UIEdgeInsetsMake(5, 5, 5, 5);
    
    return insets;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    
    return 5.0f;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    
    return 0.0f;
}

#pragma mark - Product Search

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    [searchBar resignFirstResponder];
    
    if (searchBar.text.length<=0) return;
    
    [[AppDelegate instance] showBusyView:@"Loading..."];
    
    [WebHandler searchProductsWithCriteria:searchBar.text withCallback:^(id object, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            self.searchProducts = (NSMutableArray *)object;
            
            if (self.searchProducts.count > 0) {
                UINavigationController *productVCNav = [self.storyboard instantiateViewControllerWithIdentifier:@"ProductViewNavigation"];
                DGHProductViewController *productView = [[productVCNav viewControllers] firstObject];
                
                productView.isProductSearch = YES;
                productView.products = self.searchProducts;
                
                [self.sideMenuViewController setContentViewController:productVCNav];
                [self.sideMenuViewController hideMenuViewController];
            }
            else {
                [HelperClass showAlertWithMessage:ALERT_NO_SEARCH_RESULT];
            }
            
            [[AppDelegate instance] hideBusyView];
        });
    }];
    
}

@end
