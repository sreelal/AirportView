//
//  AVHFlightInfoViewController.m
//  AVH
//
//  Created by Anamika on 5/13/15.
//  Copyright (c) 2015 Sreelal H. All rights reserved.
//

#import "AVHFlightInfoViewController.h"
#import "WebHandler.h"
#import "FlightInfoTableViewCell.h"
#import "AppDelegate.h"
#import "Flight.h"

@interface AVHFlightInfoViewController ()

@property (nonatomic, strong) NSMutableArray *flightStatuses;

@end

@implementation AVHFlightInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    
    [[AppDelegate instance] showBusyView:@"Loading Flight Info ..."];
    
    [WebHandler getFlightDepInfoWithCallback:^(id object, NSError *error) {
        
            dispatch_async(dispatch_get_main_queue(), ^{
                if (object) {
                    _flightStatuses = (NSMutableArray *)object;
                    [flightTableView reloadData];
                }
                [[AppDelegate instance] hideBusyView];
            });
        
        NSLog(@"%ld", _flightStatuses.count);
    }];
    
    [self getFlights];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TableView Delegates

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _flightStatuses.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Flight *flight = _flightStatuses[indexPath.row];
    
    FlightInfoTableViewCell *flightInfoCell = [tableView dequeueReusableCellWithIdentifier:@"flightCell"];
    flightInfoCell.flighNumberLbl.text = [NSString stringWithFormat:@"%@ %@", flight.flightCode, flight.flightNumber];
    flightInfoCell.flightNameLbl.text  = flight.flightName;
    flightInfoCell.arrDepLbl.text      = flight.arrivalAirport;
    flightInfoCell.arrdepTimeLbl.text  = flight.departureTime;
    
    return flightInfoCell;
}


- (void)getFlights
{
    @autoreleasepool {
        
        NSString* path = @"http://tati2001:7303536783e644c559cc09bd800c427e18ec6c20@flightxml.flightaware.com/json/FlightXML2/Enroute?airport=ACC&filter=''&howMany=100&offset=0";
        
        
        NSMutableURLRequest* _request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:path]];
        
        [_request setHTTPMethod:@"GET"];
        
        
        NSURLResponse *response = nil;
        
        NSError *error = nil;
        
        
        NSData* _connectionData = [NSURLConnection sendSynchronousRequest:_request returningResponse:&response error:&error];
        
        if(nil != error)
        {
            NSLog(@"Error: %@", error);
        }
        else
        {
            
            NSMutableDictionary* json = nil;
            
            
            if(nil != _connectionData)
            {
                json = [NSJSONSerialization JSONObjectWithData:_connectionData options:NSJSONReadingMutableContainers error:&error];
            }
            
            if (error || !json)
            {
                NSLog(@"Could not parse loaded json with error:%@", error);
            }
            else
            {
                
                NSMutableDictionary *routeRes;
                
                routeRes = [json objectForKey:@"EnrouteResult"];
                
                NSMutableArray *res;
                
                res = [routeRes objectForKey:@"enroute"];
                
                for(NSMutableDictionary *flight in res)
                {
                    NSLog(@"Flight : %@", flight);
                    
                    //NSLog(@"ident is %@, aircrafttype is %@, originName is %@, origin is %@", [flight objectForKey:@"ident"], [flight objectForKey:@"aircrafttype"], [flight objectForKey:@"originName"], [flight objectForKey:@"origin"]);
                    
                }
                
            }
            
            _connectionData = nil;
        }
        
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
