//
//  HelperClass.h
//  DeviceGH
//
//  Created by Sreelash S on 16/12/14.
//  Copyright (c) 2014 Sreelal H. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"
#import "MBProgressHUD.h"
#import "Reachability.h"

@interface HelperClass : NSObject

+ (BOOL)hasNetwork;

+ (BOOL)cacheJsonForData:(id)data withName:(NSString *)fileName;
+ (id)getCachedJsonFor:(NSString *)fileName;

+ (BOOL)cacheImageWithData:(NSData *)imageData withName:(NSString *)imageName;
+ (void)loadImageWithURL:(NSString *)imageURL andCompletionBlock:(void(^)(UIImage *img, NSData *imgData))block;
+ (void)getCachedImageWithName:(NSString *)imageName withCompletionBlock:(void(^)(UIImage *img))block;

+ (NSDictionary *)getRightBarButtonItemTextAttributes;

+ (NSString *)getStringDateFromTimeStamp:(NSString *)timeStamp;

+ (BOOL)is4thGeneration;

+ (BOOL)isIphone6;

+ (BOOL)isIphone6Plus;

+ (BOOL)is6thGeneration;

+ (void)showAlertWithMessage:(NSString *)message;

@end
