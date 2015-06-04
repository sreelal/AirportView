//
//  HelperClass.m
//  DeviceGH
//
//  Created by Sreelash S on 16/12/14.
//  Copyright (c) 2014 Sreelal H. All rights reserved.
//

#import "HelperClass.h"
#import "Constants.h"


@implementation HelperClass
@synthesize bookingInfoDict;

+ (id)sharedInstance {
    
    static HelperClass *sharedMyInstance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedMyInstance = [[self alloc] init];
        
        sharedMyInstance.bookingInfoDict = [[NSMutableDictionary alloc] init];
    });
    
    return sharedMyInstance;
}

+ (BOOL)hasNetwork {
    
    BOOL status;
    
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    
    if (networkStatus == NotReachable) status = NO;
    else status = YES;
    
    return status;
}

+ (BOOL)cacheJsonForData:(id)data withName:(NSString *)fileName {
    
    BOOL isCached;
    
    NSString* cachedDirectoryName = [CacheDirectory stringByAppendingPathComponent:fileName];
    
    isCached = [data writeToFile:cachedDirectoryName atomically:YES];
    
    return isCached;
}

+ (id)getCachedJsonFor:(NSString *)fileName {
    
    id cachedObject = nil;
    
    NSString *filePath = [CacheDirectory stringByAppendingPathComponent:fileName];
    
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:filePath];
    
    if (fileExists) {
        cachedObject = [NSArray arrayWithContentsOfFile:filePath];//[NSDictionary dictionaryWithContentsOfFile:filePath];
    }
    
    return cachedObject;
}

+ (void)loadImageWithURL:(NSString *)imageURL andCompletionBlock:(void(^)(UIImage *img, NSData *imgData))block {
    
    NSURL *url = [NSURL URLWithString:imageURL];
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
    
    dispatch_async(queue, ^{
        NSData *data        = [NSData dataWithContentsOfURL:url];
        UIImage *image      = [UIImage imageWithData:data];
        
        block(image, data);
    });
}

+ (BOOL)cacheImageWithData:(NSData *)imageData withName:(NSString *)imageName {
    
    BOOL isCached = NO;
    
    if (imageData && imageName) {
        NSString *imagePath = [CacheDirectory stringByAppendingPathComponent:imageName];
        
        isCached = [imageData writeToFile:imagePath atomically:YES];        
    }
    
    return isCached;
}

+ (void)getCachedImageWithName:(NSString *)imageName withCompletionBlock:(void(^)(UIImage *img))block {
    
    NSString *filePath = [CacheDirectory stringByAppendingPathComponent:imageName];
    UIImage *image     = [UIImage imageWithContentsOfFile:filePath];
    
    block(image);
}

+ (NSDictionary *)getRightBarButtonItemTextAttributes {
    
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8];
    shadow.shadowOffset = CGSizeMake(0, 1);
    NSDictionary *rightBarButtonTextAttributes = [[NSDictionary alloc] initWithObjectsAndKeys:[UIColor lightGrayColor]
                                                  , NSForegroundColorAttributeName,
                                                  shadow, NSShadowAttributeName,
                                                  [UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:13.0], NSFontAttributeName, nil];
    
    return rightBarButtonTextAttributes;
}

+ (BOOL)is4thGeneration {
    
    BOOL status = NO;
    
    if ([UIScreen mainScreen].bounds.size.height == 480) status = YES;
    
    return status;
}

+ (BOOL)is6thGeneration {
    
    BOOL status = NO;
    
    if ([UIScreen mainScreen].bounds.size.width > 320) status = YES;
    
    return status;
}

+ (BOOL)isIphone6 {
    
    BOOL status = NO;
    
    if ([UIScreen mainScreen].bounds.size.width == 375) status = YES;
    
    return status;
}

+ (BOOL)isIphone6Plus {
    
    BOOL status = NO;
    
    if ([UIScreen mainScreen].bounds.size.width == 414) status = YES;
    
    return status;
}

+ (void)showAlertWithMessage:(NSString *)message {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:message delegate:nil cancelButtonTitle:ALERT_OK otherButtonTitles:nil, nil];
    [alert show];
}

+ (id)getFilteredObjectValueFromArrOfDictForKey:(NSString *)key andForValue:(NSString *)value fromDictArr:(NSArray *)dictArr forFilterObjKey:(NSString *)filtObjKey {
    
    id returnObj = nil;
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %@", key, value];
    NSArray *filteredResults = [dictArr filteredArrayUsingPredicate:predicate];
    
    if (filteredResults.count) {
        NSDictionary *filteredObj = [filteredResults firstObject];
        returnObj = filteredObj[filtObjKey];
    }
    
    return returnObj;
}

+ (UIBarButtonItem *)getBackButtonItemWithTarget:(id)target andAction:(SEL)action {
    
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"img_btn_back"] style:UIBarButtonItemStylePlain target:target action:action];
    
    leftBarButtonItem.imageInsets = UIEdgeInsetsMake(0, -19, 1, 0);
    [leftBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                               [UIColor blackColor], NSForegroundColorAttributeName,nil]
                                     forState:UIControlStateNormal];
    
    return leftBarButtonItem;
}

+ (UIBarButtonItem *)getNextButtonItemWithTarget:(id)target andAction:(SEL)action {
    
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"img_btn_next"] style:UIBarButtonItemStylePlain target:target action:action];
    
    leftBarButtonItem.imageInsets = UIEdgeInsetsMake(0, -15, 0, 19);
    [leftBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                               [UIColor blackColor], NSForegroundColorAttributeName,nil]
                                     forState:UIControlStateNormal];
    
    return leftBarButtonItem;
}

+ (UIBarButtonItem *)getReviewAndSubmitButton:(id)target andAction:(SEL)action {
    
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Book Now" style:UIBarButtonItemStylePlain target:target action:action];
    return rightBarButtonItem;
}

+ (UIBarButtonItem *)getUpdateButton:(id)target andAction:(SEL)action {
    
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Update" style:UIBarButtonItemStylePlain target:target action:action];
    return rightBarButtonItem;
}


#pragma mark - NSDate Helpers

+ (NSString *)getStringDateFromTimeStamp:(NSString *)timeStamp {
    
    NSString *strDate;
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[timeStamp doubleValue]];
    
    strDate = [self getStringDateFromNSDate:date];
    
    return strDate;
}

+ (NSString *)getStringDateFromNSDate:(NSDate *)date {
    
    NSString *strDate;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    strDate = [formatter stringFromDate:date];
    
    return strDate;
}

+ (NSString *)getStringDateFromNSDate:(NSDate *)date withFormat:(NSString *)format {
    
    NSString *strDate;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateFormat:format];
    
    strDate = [formatter stringFromDate:date];
    
    return strDate;
}

+ (NSDate *)getNSDateFromString:(NSString *)strDate withFormat:(NSString *)format {
    
    NSDate *date;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateFormat:format];
    
    date = [formatter dateFromString:strDate];
    
    return date;
}

+ (NSString *)getCurrentDateWithFormat:(NSString *)format {
    
    NSDate *currentDate  = [NSDate date];
    NSString *stringDate = [HelperClass getStringDateFromNSDate:currentDate withFormat:format];
    
    return stringDate;
}

+ (NSString *)getNextDayDateWithFormat:(NSString *)format {
    
    NSDate *now = [NSDate date];
    int daysToAdd = 1;
    NSDate *nextDayDate = [now dateByAddingTimeInterval:60*60*24*daysToAdd];
    NSString *stringDate = [HelperClass getStringDateFromNSDate:nextDayDate withFormat:format];
    
    return stringDate;
}

+ (NSArray *)getListOfCountries {
    
    NSArray *countries = [[NSArray alloc] initWithObjects:@"Afghanistan", @"Albania", @"Algeria", @"Andorra", @"Angola", @"Antigua and Barbuda", @"Argentina", @"Armenia", @"Aruba", @"Australia", @"Austria", @"Azerbaijan", nil];
    
    return countries;
}

@end
