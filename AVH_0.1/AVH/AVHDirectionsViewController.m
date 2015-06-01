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
#import "AppDelegate.h"
#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

#define  DESTINATION_LATITUDE 5.605124
#define  DESTINATION_LONGITUDE -0.178342

@interface AVHDirectionsViewController ()
@property (weak, nonatomic) IBOutlet MKMapView *mapControl;
@property(nonatomic, retain) CLLocationManager *locationManager;

@end

@implementation AVHDirectionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"AVH_logo.png"]];
    
    UIBarButtonItem *leftBarItem = [HelperClass getBackButtonItemWithTarget:self andAction:@selector(navgationBackClicked:)];
    leftBarItem.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = leftBarItem;
    
    
    UIBarButtonItem *righttBarItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
                                                                                 target:self
                                                                                 action:@selector(loadDirectionsFromCurrentPosition)];
    righttBarItem.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = righttBarItem;
    
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    
    CLLocationCoordinate2D location = CLLocationCoordinate2DMake(DESTINATION_LATITUDE, DESTINATION_LONGITUDE);
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
    [annotation setCoordinate:location];
    [annotation setTitle:@"Airport View Hotel"]; //You can set the subtitle too
    [_mapControl addAnnotation:annotation];
    [_mapControl setCenterCoordinate:location];
    
    if(IS_OS_8_OR_LATER) {

        self.locationManager = [[CLLocationManager alloc] init];
        [self.locationManager requestAlwaysAuthorization];
        [self.locationManager requestWhenInUseAuthorization];
    }

    [self loadDirectionsFromCurrentPosition];
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

- (void)loadDirectionsFromCurrentPosition{
    
    [[AppDelegate instance] showBusyView:@"Loading ..."];

    for (id<MKOverlay> overlayToRemove in self.mapControl.overlays)
    {
        if ([overlayToRemove isKindOfClass:[MKPolyline class]])
        {
            [self.mapControl removeOverlay:overlayToRemove];
        }
    }
    
    MKMapItem *srcMapItem = [MKMapItem mapItemForCurrentLocation];
    [srcMapItem setName:@""];
    
    MKPlacemark *destination = [[MKPlacemark alloc]initWithCoordinate:CLLocationCoordinate2DMake(DESTINATION_LATITUDE, DESTINATION_LONGITUDE) addressDictionary:[NSDictionary dictionaryWithObjectsAndKeys:@"",@"", nil] ];
    
    MKMapItem *distMapItem = [[MKMapItem alloc]initWithPlacemark:destination];
    [distMapItem setName:@""];
    
    MKDirectionsRequest *request = [[MKDirectionsRequest alloc]init];
    [request setSource:srcMapItem];
    [request setDestination:distMapItem];
    [request setTransportType:MKDirectionsTransportTypeAutomobile];
    
    MKDirections *direction = [[MKDirections alloc]initWithRequest:request];
    
    [direction calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse *response, NSError *error) {
        
        [[AppDelegate instance] hideBusyView];

        NSLog(@"response = %@",response);
        NSArray *arrRoutes = [response routes];
        [arrRoutes enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            
            MKRoute *route = [response.routes firstObject];
            [self.mapControl addOverlay:route.polyline level:MKOverlayLevelAboveRoads];
            
            
            //Set visible map rect
            MKMapRect zoomRect = MKMapRectNull;
            for (int idx = 0; idx < sizeof(route.polyline.points); idx++) {
                MKMapPoint annotationPoint = route.polyline.points[idx];
                MKMapRect pointRect = MKMapRectMake(annotationPoint.x, annotationPoint.y, 0, 0);
                if (MKMapRectIsNull(zoomRect)) {
                    zoomRect = pointRect;
                } else {
                    zoomRect = MKMapRectUnion(zoomRect, pointRect);
                }
            }
            zoomRect = MKMapRectInset(zoomRect, 0, 0);
            [self.mapControl setVisibleMapRect:zoomRect animated:YES];
            
        }];
    }];
}


-(MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay{
    MKPolylineRenderer *polylineRender = [[MKPolylineRenderer alloc] initWithOverlay:overlay];
    polylineRender.lineWidth = 5.0f;
    polylineRender.strokeColor = [UIColor redColor];
    return polylineRender;
}



@end
