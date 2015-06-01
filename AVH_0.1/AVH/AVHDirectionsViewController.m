//
//  AVHDirectionsViewController.m
//  AVH
//
//  Created by Sreelal  Hamsavahanan on 29/05/15.
//  Copyright (c) 2015 Sreelal H. All rights reserved.
//

#import "AVHDirectionsViewController.h"
#import <MapKit/MapKit.h>
#import "HelperClass.h"

@interface AVHDirectionsViewController ()
@property (weak, nonatomic) IBOutlet MKMapView *mapControl;

@end

@implementation AVHDirectionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"AVH_logo.png"]];
    
    UIBarButtonItem *leftBarItem = [HelperClass getBackButtonItemWithTarget:self andAction:@selector(navgationBackClicked:)];
    leftBarItem.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = leftBarItem;
    
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    
    CLLocationCoordinate2D location = CLLocationCoordinate2DMake(5.605124, -0.178342);
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
    [annotation setCoordinate:location];
    [annotation setTitle:@"Airport View Hotel"]; //You can set the subtitle too
    [_mapControl addAnnotation:annotation];
    [_mapControl setCenterCoordinate:location];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)navgationBackClicked:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
}

@end
