//
//  DGHContentViewController.m
//  DeviceGH
//
//  Created by Sreelal H on 07/12/14.
//  Copyright (c) 2014 Sreelal H. All rights reserved.
//

#import "DGHContentViewController.h"
#import "AppDelegate.h"
#import "WebHandler.h"
#import "DGHCategoryCollectionViewCell.h"
#import "DGHProductViewController.h"
#import "DGHEnquireViewController.h"
#import "HelperClass.h"

@interface DGHContentViewController ()

@property (nonatomic, strong) NSMutableArray *subCategories;

- (IBAction)onHome:(id)sender;

@end

@implementation DGHContentViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    self.title = self.category.name;
    
    [self loadSubCategories];
    
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8];
    shadow.shadowOffset = CGSizeMake(0, 1);
    NSDictionary *rightBarButtonTextAttributes = [[NSDictionary alloc] initWithObjectsAndKeys:[UIColor lightGrayColor]
                                                  , NSForegroundColorAttributeName,
                                                  shadow, NSShadowAttributeName,
                                                  [UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:13.0], NSFontAttributeName, nil];
    
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:rightBarButtonTextAttributes forState:UIControlStateNormal];
    
    //self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo_44x44.jpg"]];
    
    NSLog(@"Selected Category Id: %@", self.category.Id);
}

- (void)viewWillAppear:(BOOL)animated{
    
    self.contenLabel.text = self.contentValue;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Webservice Implementations

- (void)loadSubCategories {
    
    [[AppDelegate instance] showBusyView:@"Loading..."];
    
    [WebHandler getSubCategoriesForCategoryId:self.category.Id withCallback:^(id object, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.subCategories = (NSMutableArray *)object;
            
            if (self.subCategories.count) {
                [categoriesCollectionView reloadData];
            }
            
            [[AppDelegate instance] hideBusyView];
        });
    }];
}

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    
    return self.subCategories.count;
}

- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    DGHCategoryCollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"CategoryCell" forIndexPath:indexPath];
    
    ProductCategory *category = self.subCategories[indexPath.row];
    
    cell.categoryNameLabel.text = category.name;
    
    [cell setupBg];
    
    [cell loadCategoryImageForCategory:category];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UINavigationController *navController;
    
    ProductCategory *selectedCategory = self.subCategories[indexPath.row];
    
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

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat pixel;
    CGSize size;
    
    if ([HelperClass isIphone6Plus]) pixel = 200;
    else pixel = [UIScreen mainScreen].bounds.size.width/2;
    
    size = CGSizeMake(pixel, pixel);
    
    return size;
}

- (UIEdgeInsets)collectionView:
(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    UIEdgeInsets insets = UIEdgeInsetsMake(0, 0, 0, 0);;
    
    return insets;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    
    return 0.0f;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    
    return 0.0f;
}

#pragma mark - Button Actions

- (IBAction)equireListClicked:(id)sender {
    
    UINavigationController *enquireVCNav = [self.storyboard instantiateViewControllerWithIdentifier:@"EnquireViewNavigation"];
    
    [self.sideMenuViewController setContentViewController:enquireVCNav];
    [self.sideMenuViewController hideMenuViewController];
}

- (IBAction)onHome:(id)sender {
        
    if ([self.delegate respondsToSelector:@selector(onGoToHomeScreen)]) {
        
        [self.delegate onGoToHomeScreen];
    }
    
}

@end
