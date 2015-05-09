//
//  Notification.h
//  DeviceGH
//
//  Created by Sreelash S on 27/01/15.
//  Copyright (c) 2015 Sreelal H. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Notification : NSObject

@property (nonatomic, strong) NSString *Id;
@property (nonatomic, strong) NSString *message;
@property (nonatomic, strong) NSString *timeSend;

@end
