//
//  CacheManager.h
//  DeviceGH
//
//  Created by Sreelash S on 20/01/15.
//  Copyright (c) 2015 Sreelal H. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Product.h"

@interface CacheManager : NSObject

@property (nonatomic, strong) NSMutableArray *enquiryProducts;
@property (nonatomic, strong) NSString *deviceToken;

+ (id)sharedInstance;

- (BOOL)addProduct:(Product *)product;

- (void)removeProduct:(Product *)product;

- (void)saveDeviceToken:(NSString *)token;

- (NSString *)deviceToken;

- (void)saveFooterText:(NSString *)footer;

- (NSString *)footerText;

@end
