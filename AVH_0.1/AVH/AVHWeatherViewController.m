//
//  AVHWeatherViewController.m
//  AVH
//
//  Created by Sreelal H on 11/05/15.
//  Copyright (c) 2015 Sreelal H. All rights reserved.
//

#import "AVHWeatherViewController.h"
#import "WebHandler.h"
#import "WeatherTableViewCell.h"
#import "AppDelegate.h"

@interface AVHWeatherViewController ()

@property (weak, nonatomic) IBOutlet UITableView *weatherReportTable;
@property (strong, nonatomic) NSMutableDictionary *weatherData;

@end

@implementation AVHWeatherViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [[self navigationController] setNavigationBarHidden:NO animated:YES];

    _weatherData = nil;
    
    [[AppDelegate instance] showBusyView:@"Loading weather ..."];
    
    [WebHandler getWeatherInfoWithCallback:^(id object, NSError *error) {
        
        if (object) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                _weatherData = object;
                
                NSString *temp = [[_weatherData valueForKey:@"metar"] valueForKey:@"temperatureCelsius"];
                NSString *dewPt = [[_weatherData valueForKey:@"metar"] valueForKey:@"dewPointCelsius"];
                
                tempLbl.text   = [NSString stringWithFormat:@"%@ %@ C", temp, @"\u00B0"];
                dewPtLbl.text  = [NSString stringWithFormat:@"%@ %@ C", dewPt, @"\u00B0"];
                reportLbl.text = [[_weatherData valueForKey:@"metar"] valueForKey:@"reportTime"];
                windLbl.text   = _weatherData[@"metar"][@"conditions"][@"wind"][@"speedKnots"];
                
                NSArray *skyConditions = _weatherData[@"metar"][@"conditions"][@"skyConditions"];
                [skyConditions enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    skyLbl.text = obj[@"coverage"];
                }];
                
                [[AppDelegate instance] hideBusyView];
            });
          }
    }];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    WeatherTableViewCell *weatherCell = [tableView dequeueReusableCellWithIdentifier:@"weatherCell"];
    weatherCell.temperatureCelsius.text = [[_weatherData valueForKey:@"metar"] valueForKey:@"temperatureCelsius"];
    weatherCell.dewPointValue.text = [[_weatherData valueForKey:@"metar"] valueForKey:@"dewPointCelsius"];
    return weatherCell;
    
}

@end
