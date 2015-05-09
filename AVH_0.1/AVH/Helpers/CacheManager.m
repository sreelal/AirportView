//
//  CacheManager.m
//  DeviceGH
//
//  Created by Sreelash S on 20/01/15.
//  Copyright (c) 2015 Sreelal H. All rights reserved.
//

#import "CacheManager.h"
#import "Constants.h"

@implementation CacheManager

+ (id)sharedInstance {
    
    static CacheManager *sharedMyInstance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedMyInstance = [[self alloc] init];
    });
    
    return sharedMyInstance;
}

- (id)init {
    
    if (self = [super init]) {
        
        NSUserDefaults *currentDefaults = [NSUserDefaults standardUserDefaults];
        NSData *dataRepresentingSavedArray = [currentDefaults objectForKey:KEY_ENQUIRE_PRODUCTS];
        
        self.deviceToken = [currentDefaults objectForKey:KEY_DEVICE_TOKEN];
        
        if (dataRepresentingSavedArray != nil) {
            NSArray *savedArray = [NSKeyedUnarchiver unarchiveObjectWithData:dataRepresentingSavedArray];
            if (savedArray != nil)
                self.enquiryProducts = [[NSMutableArray alloc] initWithArray:savedArray];
            else
                self.enquiryProducts = [[NSMutableArray alloc] init];
        }
        else {
            self.enquiryProducts = [[NSMutableArray alloc] init];
        }
        
        NSLog(@"Enquire Products Count: %lu", (unsigned long)self.enquiryProducts.count);
    }
    
    return self;
}

- (BOOL)addProduct:(Product *)product {
    
    BOOL isAdded = NO;
    
    if (![self isProductExist:product]) {
        [self.enquiryProducts addObject:product];
        
        NSLog(@"%@ added, array count : %lu", product.name, (unsigned long)self.enquiryProducts.count);
        
        [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:self.enquiryProducts] forKey:KEY_ENQUIRE_PRODUCTS];
        
        isAdded = YES;
    }
    
    return isAdded;
}

- (void)removeProduct:(Product *)product {
    
    [self.enquiryProducts removeObject:product];
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:self.enquiryProducts] forKey:KEY_ENQUIRE_PRODUCTS];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (BOOL)isProductExist:(Product *)product {
    
    __block BOOL isExist = NO;
    
    [self.enquiryProducts enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        Product *validatingProduct = (Product *)obj;
        if ([validatingProduct.name isEqualToString:product.name] && [validatingProduct.Id isEqualToString:product.Id]) {
            isExist = YES;
            *stop = YES;
        }
    }];
    
    return isExist;
}

- (void)saveDeviceToken:(NSString *)token {
    
    [[NSUserDefaults standardUserDefaults] setObject:token forKey:KEY_DEVICE_TOKEN];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)deviceToken {
    
    NSUserDefaults *currentDefaults = [NSUserDefaults standardUserDefaults];
    return [currentDefaults objectForKey:KEY_DEVICE_TOKEN];
}

- (void)saveFooterText:(NSString *)footer {
    
    [[NSUserDefaults standardUserDefaults] setObject:footer forKey:KEY_FOOTER];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)footerText {
    
    NSUserDefaults *currentDefaults = [NSUserDefaults standardUserDefaults];
    return [currentDefaults objectForKey:KEY_FOOTER];
}

@end
