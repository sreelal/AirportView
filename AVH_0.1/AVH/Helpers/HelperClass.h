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

@protocol AVHBookingProtocol <NSObject>
- (void)saveInformations;
- (NSMutableDictionary*)retrieveInformations;
- (void)enableEditMode;
@end


@interface HelperClass : NSObject

@property (nonatomic, strong) NSMutableDictionary *bookingInfoDict;

+ (BOOL)hasNetwork;

+ (BOOL)cacheJsonForData:(id)data withName:(NSString *)fileName;

+ (id)getCachedJsonFor:(NSString *)fileName;

+ (BOOL)cacheImageWithData:(NSData *)imageData withName:(NSString *)imageName;

+ (void)loadImageWithURL:(NSString *)imageURL andCompletionBlock:(void(^)(UIImage *img, NSData *imgData))block;
+ (void)getCachedImageWithName:(NSString *)imageName withCompletionBlock:(void(^)(UIImage *img))block;

+ (NSDictionary *)getRightBarButtonItemTextAttributes;

+ (BOOL)is4thGeneration;

+ (BOOL)isIphone6;

+ (BOOL)isIphone6Plus;

+ (BOOL)is6thGeneration;

+ (void)showAlertWithMessage:(NSString *)message;

+ (id)getFilteredObjectValueFromArrOfDictForKey:(NSString *)key andForValue:(NSString *)value fromDictArr:(NSArray *)dictArr forFilterObjKey:(NSString *)filtObjKey;

+ (UIBarButtonItem *)getBackButtonItemWithTarget:(id)target andAction:(SEL)action;

+ (UIBarButtonItem *)getNextButtonItemWithTarget:(id)target andAction:(SEL)action;

//NSDate Helper Mehtods

+ (NSString *)getStringDateFromTimeStamp:(NSString *)timeStamp;

+ (NSString *)getCurrentDateWithFormat:(NSString *)format;

+ (NSString *)getNextDayDateWithFormat:(NSString *)format;

+ (NSString *)getStringDateFromNSDate:(NSDate *)date withFormat:(NSString *)format;

+ (NSDate *)getNSDateFromString:(NSString *)strDate withFormat:(NSString *)format;

+ (NSArray *)getListOfCountries;

+ (UIBarButtonItem *)getReviewAndSubmitButton:(id)target andAction:(SEL)action;

+ (UIBarButtonItem *)getUpdateButton:(id)target andAction:(SEL)action;


@end
