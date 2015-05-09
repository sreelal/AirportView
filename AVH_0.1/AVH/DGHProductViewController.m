//
//  DGHProductViewController.m
//  DeviceGH
//
//  Created by Sreelash S on 19/01/15.
//  Copyright (c) 2015 Sreelal H. All rights reserved.
//

#import "DGHProductViewController.h"
#import "HelperClass.h"
#import "WebHandler.h"
#import "AppDelegate.h"
#import "Product.h"
#import "DGHProductCell.h"
#import "CacheManager.h"
#import "DGHEnquireViewController.h"
#import "DGHProductInfoViewController.h"

@interface DGHProductViewController () <ProductCellDelegate>

@end

@implementation DGHProductViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title = self.category.name;
    
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:[HelperClass getRightBarButtonItemTextAttributes] forState:UIControlStateNormal];
    
    if (self.isProductSearch) [productsCollectionView reloadData];
    else [self loadProducts];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Webservice Implementations

- (void)loadProducts {
    
    [[AppDelegate instance] showBusyView:@"Loading..."];
    
    [WebHandler getProductsForCategoryId:self.category.Id withCallback:^(id object, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.products = (NSMutableArray *)object;
            
            if (self.products.count) {
                [productsCollectionView reloadData];
            }
            
            [[AppDelegate instance] hideBusyView];
        });
    }];
}

#pragma mark - Button Actions

- (IBAction)equireListClicked:(id)sender {
    
    UINavigationController *enquireVCNav = [self.storyboard instantiateViewControllerWithIdentifier:@"EnquireViewNavigation"];
    //DGHEnquireViewController *enquireView = [[enquireVCNav viewControllers] firstObject];
    
    [self.sideMenuViewController setContentViewController:enquireVCNav];
    [self.sideMenuViewController hideMenuViewController];
}

#pragma mark - UICollectionView Delegates

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    
    return self.products.count;
}

- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    DGHProductCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"ProductCell" forIndexPath:indexPath];
    
    cell.delegate = self;
    
    Product *product = self.products[indexPath.row];
    
    cell.productNameLabel.text = product.name;
    
    [cell setupBg];
    
    [cell loadProductImageForProduct:product];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat pixel;
    CGSize size;
    
    if ([HelperClass isIphone6Plus]) pixel = 186;
    else pixel = [UIScreen mainScreen].bounds.size.width/2;
    
    size = CGSizeMake(pixel, 203);
    
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


#pragma mark - ProductCell Delegate

- (void)addProductToEnquireList:(Product *)product {
    
    NSString *alertMessage;
    
    BOOL isAdded = [[CacheManager sharedInstance] addProduct:product];
    
    if (isAdded) alertMessage = @"Product added to enquiry list.";
    else alertMessage = @"Product already added to enquiry list.";
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:alertMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    
    [alert show];
}

- (void)viewProductInfo:(Product *)product {
    
    UINavigationController *productInfoVCNav = [self.storyboard instantiateViewControllerWithIdentifier:@"ProductInfoViewNavigation"];
    DGHProductInfoViewController *productInfoView = [[productInfoVCNav viewControllers] firstObject];
    productInfoView.product = product;
    
    [self.sideMenuViewController setContentViewController:productInfoVCNav];
    [self.sideMenuViewController hideMenuViewController];
}

@end
