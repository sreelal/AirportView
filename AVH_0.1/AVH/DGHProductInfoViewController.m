//
//  DGHProductInfoViewController.m
//  DeviceGH
//
//  Created by Sreelash S on 25/01/15.
//  Copyright (c) 2015 Sreelal H. All rights reserved.
//

#import "DGHProductInfoViewController.h"
#import "HelperClass.h"
#import "AppDelegate.h"
#import "WebHandler.h"
#import "DGHEnquireViewController.h"
#import "CacheManager.h"

@interface DGHProductInfoViewController ()

@end

@implementation DGHProductInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    segmentControl.tintColor = [UIColor colorWithPatternImage: [UIImage imageNamed: @"NavigationBg.png"]];
    segmentControl.backgroundColor = [UIColor whiteColor];
    
    [segmentControl addTarget:self
                        action:@selector(segmentSwitch:)
              forControlEvents:UIControlEventValueChanged];
    
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:[HelperClass getRightBarButtonItemTextAttributes] forState:UIControlStateNormal];
    
    [self loadProductInfo];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#

- (void)loadProductInfo {
    
    [[AppDelegate instance] showBusyView:@"Loading..."];
    
    [WebHandler getProductInfoWithId:self.product.Id withCallback:^(id object, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.productInfo = (ProductInfo *)object;
            
            if (self.productInfo) {
                [self bindProductInfo];
            }
            
            [[AppDelegate instance] hideBusyView];
        });
    }];
}

- (void)bindProductInfo {
    
    NSString *imageURL = self.productInfo.imageURL;
    NSString *imageName = [NSString stringWithFormat:@"%@_%@", self.productInfo.name, self.productInfo.Id];
    
    productNameLabel.text = self.productInfo.name;
    [descriptionWebView loadHTMLString:self.productInfo.prodDescription baseURL:nil];
    [specificationWebView loadHTMLString:self.productInfo.prodSpecification baseURL:nil];
    
    CALayer *borderLayer = [CALayer layer];
    CGRect borderFrame = CGRectMake(0, 0, (productImageView.frame.size.width), (productImageView.frame.size.height));
    [borderLayer setBackgroundColor:[[UIColor clearColor] CGColor]];
    [borderLayer setFrame:borderFrame];
    [borderLayer setCornerRadius:5.0];
    [borderLayer setBorderWidth:1.0];
    [borderLayer setBorderColor:[[UIColor lightGrayColor] CGColor]];
    [productImageView.layer addSublayer:borderLayer];
    
    if (imageURL) {
        [HelperClass getCachedImageWithName:imageName withCompletionBlock:^(UIImage *img) {
            if (img) {
                productImageView.image = img;
                NSLog(@"Cached Image Loaded for %@", imageName);
            }
            else {
                [HelperClass loadImageWithURL:imageURL andCompletionBlock:^(UIImage *img, NSData *imgData) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (img) productImageView.image = img;
                    });
                    
                    if (imgData) {
                        BOOL isImageCached = [HelperClass cacheImageWithData:imgData withName:imageName];
                        
                        if (isImageCached) NSLog(@"%@ Image Cached", imageName);
                        else NSLog(@"%@ Image Not Cached", imageName);
                    }
                }];
            }
        }];
    }
    else {
        productImageView.image = [UIImage imageNamed:@"no_image.png"];
    }
}

#pragma mark - Button Actions

- (IBAction)addProductToEnquireList {
    
    NSString *alertMessage;
    
    BOOL isAdded = [[CacheManager sharedInstance] addProduct:self.product];
    
    if (isAdded) alertMessage = @"Product added to enquiry list.";
    else alertMessage = @"Product already added to enquiry list.";
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:alertMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    
    [alert show];
}

- (IBAction)equireListClicked:(id)sender {
    
    UINavigationController *enquireVCNav = [self.storyboard instantiateViewControllerWithIdentifier:@"EnquireViewNavigation"];
    //DGHEnquireViewController *enquireView = [[enquireVCNav viewControllers] firstObject];
    
    [self.sideMenuViewController setContentViewController:enquireVCNav];
    [self.sideMenuViewController hideMenuViewController];
}

- (IBAction)segmentSwitch:(id)sender {
    
    UISegmentedControl *segmentedControl = (UISegmentedControl *) sender;
    NSInteger selectedSegment = segmentedControl.selectedSegmentIndex;
    
    if (selectedSegment == 0) {
        specificationWebView.hidden = YES;
        descriptionWebView.hidden = NO;
    }
    else{
        specificationWebView.hidden = NO;
        descriptionWebView.hidden = YES;
    }
}

@end
