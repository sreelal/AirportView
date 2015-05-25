//
//  AVHRoomsRatesViewController.m
//  AVH
//
//  Created by Sreelal H on 25/05/15.
//  Copyright (c) 2015 Sreelal H. All rights reserved.
//

#import "AVHRoomsRatesViewController.h"
#import "WebHandler.h"
#import "AVHHotelCellTableViewCell.h"

@interface AVHRoomsRatesViewController ()

@property (nonatomic, weak) IBOutlet UITableView *hotelsTable;
@property (nonatomic, strong) NSDictionary *hotelDetails;

@end

@implementation AVHRoomsRatesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [WebHandler getHotelsList:^(id object, NSError *error) {
        
        if (object) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                _hotelDetails = object;
                [_hotelsTable reloadData];
            });
      
        }
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - TableView Delegates

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSArray *hotelsList = _hotelDetails[@"packages"];
    return [hotelsList count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    static NSString *cellId = @"hotelCell";
    AVHHotelCellTableViewCell *hotelCell = (AVHHotelCellTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
    
    NSArray *hotelsList = _hotelDetails[@"packages"];

    NSDictionary *hotelDetails = hotelsList[indexPath.row];
    
    hotelCell.hotelRate.text = [NSString stringWithFormat:@"%@ $",hotelDetails[@"cost_per_day"]];
    hotelCell.hotelDescription.text = hotelDetails[@"description"];
    hotelCell.hotelduration.text = hotelDetails[@"name"];
    if (hotelCell.hotelDescription.text.length > 150) {
        hotelCell.hotelDescription.text = [NSString stringWithFormat:@"%@...", [hotelCell.hotelDescription.text substringToIndex:150]];
    }
    
    return hotelCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 210;
}

@end
