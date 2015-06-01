//
//  AVHDataHandler.h
//  AVH
//
//  Created by Sreelal H on 01/06/15.
//  Copyright (c) 2015 Sreelal H. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AVHDataHandler : NSObject

@property(nonatomic, retain)NSMutableDictionary *bookingDataHolder;

+ (id)sharedManager;
@end
