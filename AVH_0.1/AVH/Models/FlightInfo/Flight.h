//
//  Flight.h
//  AVH
//
//  Created by Anamika on 5/19/15.
//  Copyright (c) 2015 Sreelal H. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Flight : NSObject

@property (nonatomic, strong) NSString *flightCode;
@property (nonatomic, strong) NSString *flightName;
@property (nonatomic, strong) NSString *flightNumber;
@property (nonatomic, strong) NSString *departureTime;
@property (nonatomic, strong) NSString *arrivalTime;
@property (nonatomic, strong) NSString *departureAirport;
@property (nonatomic, strong) NSString *arrivalAirport;

@end
