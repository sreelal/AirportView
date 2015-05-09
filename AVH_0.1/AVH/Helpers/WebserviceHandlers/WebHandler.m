//
//  RequestHandler.h
//  DMT
//
//  Created by Sreelash S on 10/08/14.
//  Copyright (c) 2014 Sreelash S. All rights reserved.
//

#import "WebHandler.h"
#import "Constants.h"
#import "HelperClass.h"
#import "ProductCategory.h"
#import "Product.h"
#import "Banner.h"
#import "ProductInfo.h"
#import "Notification.h"

@implementation WebHandler

+ (void)getCategoriesWithCallback:(ResponseCallback)callback {
    
    /////////////////////////////Handling Offline Mode////////////////////////////////////////////
    if (![HelperClass hasNetwork]) {
        [self showAlertWithMessage:ALERT_INTERNET_FAILURE];
        
        id cachedCategory = [HelperClass getCachedJsonFor:CACHE_ID_CATEGORY];
        
        NSLog(@"Cached Category: %@", cachedCategory);
        
        if (cachedCategory != nil) {
            NSMutableArray *categories = [self parseCategoriesForResult:cachedCategory];
            
            callback(categories, nil);
        }
        else callback(nil, nil);
        
        return;
    }
    //////////////////////////////////////////////////////////////////////////////////////////////
    
    NSString *serviceURL = [NSString stringWithFormat:@"%@%@", SERVICE_URL_ROOT, SERVICE_CATEGORY];
    
    [RequestHandler getRequestWithURL:serviceURL withCallback:^(id result, NSError *error) {
        
        if (result != nil) {
            BOOL isCached = [HelperClass cacheJsonForData:result withName:CACHE_ID_CATEGORY];
            
            if (isCached) NSLog(@"Category Successfully Cached");
            else NSLog(@"Failed Category Caching");
        }
        else if (result == nil || error) {
            result = [HelperClass getCachedJsonFor:CACHE_ID_CATEGORY];
            
            NSLog(@"Cached Result: %@", result);
        }
        
        NSMutableArray *categories = [self parseCategoriesForResult:result];
        
        callback(categories, error);
    }];
}

+ (NSMutableArray *)parseCategoriesForResult:(id)categoryResult {
    
    NSMutableArray *parsedCategories = [[NSMutableArray alloc] init];
    
    [categoryResult enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSDictionary    *categoryDict = obj;
        
        ProductCategory *category = [[ProductCategory alloc] init];
        category.Id         = categoryDict[@"category_id"];
        category.name       = categoryDict[@"name"];
        category.imageURL   = [self checkForNSNULL:categoryDict[@"image"]];
        category.children   = [categoryDict[@"children"] integerValue];
        category.sortOrder  = categoryDict[@"sort_order"];
        
        [parsedCategories addObject:category];
        
        category = nil;
    }];
    
    return parsedCategories;
}

+ (void)getBannerImagesWithCallback:(ResponseCallback)callback {
    
    /////////////////////////////Handling Offline Mode////////////////////////////////////////////
    if (![HelperClass hasNetwork]) {
        //[self showAlertWithMessage:ALERT_INTERNET_FAILURE];
        
        id cachedBanner = [HelperClass getCachedJsonFor:CACHE_ID_BANNER];
        
        NSLog(@"Cached Category: %@", cachedBanner);
        
        if (cachedBanner != nil) {
            NSMutableArray *banners = [self parseBannerImagesForResult:cachedBanner];
            
            callback(banners, nil);
        }
        else callback(nil, nil);
        
        return;
    }
    //////////////////////////////////////////////////////////////////////////////////////////////
    
    NSString *serviceURL = [NSString stringWithFormat:@"%@%@", SERVICE_URL_ROOT, SERVICE_BANNER];
    
    [RequestHandler getRequestWithURL:serviceURL withCallback:^(id result, NSError *error) {
        
        if (result != nil) {
            BOOL isCached = [HelperClass cacheJsonForData:result withName:CACHE_ID_BANNER];
            
            if (isCached) NSLog(@"Banner Successfully Cached");
            else NSLog(@"Failed Banner Caching");
        }
        else if (result == nil || error) {
            result = [HelperClass getCachedJsonFor:CACHE_ID_BANNER];
            
            NSLog(@"Cached Result: %@", result);
        }
        
        NSMutableArray *banners = [self parseBannerImagesForResult:result];
        
        callback(banners, error);
    }];
}

+ (NSMutableArray *)parseBannerImagesForResult:(id)bannerResult {
    
    NSMutableArray *bannerImages = [[NSMutableArray alloc] init];
    
    [bannerResult enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSDictionary *bannerDict = obj;
        
        Banner *banner = [[Banner alloc] init];
        banner.title          = bannerDict[@"title"];
        banner.bannerImageUrl = bannerDict[@"image"];
        
        [bannerImages addObject:banner];
        
        banner = nil;
    }];
    
    return bannerImages;
}

+ (void)getSubCategoriesForCategoryId:(NSString *)categoryId withCallback:(ResponseCallback)callback {
    
    NSString *subCategoryCacheId = [NSString stringWithFormat:@"%@%@%@", CACHE_ID_SUB_CATEGORY, categoryId, CACHE_ID_EXTENSION];
    
    /////////////////////////////Handling Offline Mode////////////////////////////////////////////
    if (![HelperClass hasNetwork]) {
        [self showAlertWithMessage:ALERT_INTERNET_FAILURE];
        
        subCategoryCacheId = [NSString stringWithFormat:@"%@%@%@", CACHE_ID_SUB_CATEGORY, categoryId, CACHE_ID_EXTENSION];
        id cachedSubCategory = [HelperClass getCachedJsonFor:subCategoryCacheId];
        
        NSLog(@"Cached Category: %@", cachedSubCategory);
        
        if (cachedSubCategory != nil) {
            NSMutableArray *subCategories = [self parseCategoriesForResult:cachedSubCategory];
            
            callback(subCategories, nil);
        }
        else callback(nil, nil);
        
        return;
    }
    //////////////////////////////////////////////////////////////////////////////////////////////
    
    NSString *serviceURL = [NSString stringWithFormat:@"%@%@%@", SERVICE_URL_ROOT, SERVICE_SUB_CATEGORY, categoryId];
    
    NSLog(@"Service URL : %@", serviceURL);
    
    [RequestHandler getRequestWithURL:serviceURL withCallback:^(id result, NSError *error) {
        
        if (result != nil) {
            BOOL isCached = [HelperClass cacheJsonForData:result withName:subCategoryCacheId];
            
            if (isCached) NSLog(@"Sub Category Successfully Cached");
            else NSLog(@"Failed Sub Category Caching");
        }
        else if (result == nil || error) {
            result = [HelperClass getCachedJsonFor:subCategoryCacheId];
            
            NSLog(@"Cached Result: %@", result);
        }
        
        NSMutableArray *subCategories = [self parseCategoriesForResult:result];
        
        callback(subCategories, error);
    }];
}

+ (void)getProductsForCategoryId:(NSString *)categoryId withCallback:(ResponseCallback)callback {
    
    NSString *productsCacheId = [NSString stringWithFormat:@"%@%@%@", CACHE_ID_CATEGORY_PRO, categoryId, CACHE_ID_EXTENSION];
    
    /////////////////////////////Handling Offline Mode////////////////////////////////////////////
    if (![HelperClass hasNetwork]) {
        [self showAlertWithMessage:ALERT_INTERNET_FAILURE];
        
        productsCacheId = [NSString stringWithFormat:@"%@%@%@", CACHE_ID_CATEGORY_PRO, categoryId, CACHE_ID_EXTENSION];
        id cachedProducts = [HelperClass getCachedJsonFor:productsCacheId];
        
        NSLog(@"Cached Category: %@", cachedProducts);
        
        if (cachedProducts != nil) {
            NSMutableArray *products = [self parseProductForResult:cachedProducts];
            
            callback(products, nil);
        }
        else callback(nil, nil);
        
        return;
    }
    //////////////////////////////////////////////////////////////////////////////////////////////
    
    NSString *serviceURL = [NSString stringWithFormat:@"%@%@%@", SERVICE_URL_ROOT, SERVICE_PRODUCT, categoryId];
    
    NSLog(@"Service URL : %@", serviceURL);
    
    [RequestHandler getRequestWithURL:serviceURL withCallback:^(id result, NSError *error) {
        
        if (result != nil) {
            BOOL isCached = [HelperClass cacheJsonForData:result withName:productsCacheId];
            
            if (isCached) NSLog(@"Product Successfully Cached");
            else NSLog(@"Failed Product Caching");
        }
        else if (result == nil || error) {
            result = [HelperClass getCachedJsonFor:productsCacheId];
            
            NSLog(@"Cached Result: %@", result);
        }
        
        NSMutableArray *products;
        
        if (result != nil) products = [self parseProductForResult:result];
        
        callback(products, error);
    }];
}

+ (NSMutableArray *)parseProductForResult:(id)productResult {
    
    NSMutableArray *parsedProducts = [[NSMutableArray alloc] init];
    
    [productResult enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSDictionary    *productDict = obj;
        
        Product *product   = [[Product alloc] init];
        product.Id         = productDict[@"productId"];
        product.name       = productDict[@"name"];
        product.imageURL   = productDict[@"image"];
        
        [parsedProducts addObject:product];
        
        product = nil;
    }];
    
    return parsedProducts;
}

+ (void)getProductInfoWithId:(NSString *)productId withCallback:(ResponseCallback)callback {
    
    NSString *productCacheId = [NSString stringWithFormat:@"%@%@%@", CACHE_ID_PRODUCT, productId, CACHE_ID_EXTENSION];
    
    /////////////////////////////Handling Offline Mode////////////////////////////////////////////
    if (![HelperClass hasNetwork]) {
        [self showAlertWithMessage:ALERT_INTERNET_FAILURE];
        
        productCacheId = [NSString stringWithFormat:@"%@%@%@", CACHE_ID_PRODUCT, productId, CACHE_ID_EXTENSION];
        id cachedProduct = [HelperClass getCachedJsonFor:productCacheId];
        
        NSLog(@"Cached Category: %@", cachedProduct);
        
        if (cachedProduct != nil) {
            //NSMutableArray *products = [self parseProductForResult:cachedProducts];
            
            //callback(products, nil);
        }
        else callback(nil, nil);
        
        return;
    }
    //////////////////////////////////////////////////////////////////////////////////////////////
    
    NSString *serviceURL = [NSString stringWithFormat:@"%@%@%@", SERVICE_URL_ROOT, SERVICE_PRODUCT_INFO, productId];
    
    NSLog(@"Service URL : %@", serviceURL);
    
    [RequestHandler getRequestWithURL:serviceURL withCallback:^(id result, NSError *error) {
        
        if (result != nil) {
            BOOL isCached = [HelperClass cacheJsonForData:result withName:productCacheId];
            
            if (isCached) NSLog(@"Product Successfully Cached");
            else NSLog(@"Failed Product Caching");
        }
        else if (result == nil || error) {
            result = [HelperClass getCachedJsonFor:productCacheId];
            
            NSLog(@"Cached Result: %@", result);
        }
        
        ProductInfo *productInfo;
        
        if (result != nil) productInfo  = [self parseProductInfoForResult:result];
        
        callback(productInfo, error);
    }];
}

+ (ProductInfo *)parseProductInfoForResult:(id)productInfoResult {
    
    NSDictionary *productInfoDict = (NSDictionary *)productInfoResult;
    
    ProductInfo *productInfo = [[ProductInfo alloc] init];
    
    productInfo.prodDescription = productInfoDict[@"description"];
    productInfo.prodSpecification = productInfoDict[@"specification"];
    productInfo.Id = productInfoDict[@"product"][@"productId"];
    productInfo.name = productInfoDict[@"product"][@"name"];
    productInfo.imageURL = productInfoDict[@"product"][@"image"];
    
    return productInfo;
}

+ (void)getNotificationsWithCallback:(ResponseCallback)callback {
    
    /////////////////////////////Handling Offline Mode////////////////////////////////////////////
    if (![HelperClass hasNetwork]) {
        [self showAlertWithMessage:ALERT_INTERNET_FAILURE];
        
        id cachedNotification = [HelperClass getCachedJsonFor:CACHE_ID_NOTIFICA];
        
        NSLog(@"Cached Notificaions: %@", cachedNotification);
        
        if (cachedNotification != nil) {
            NSMutableArray *notifications = [self parseNotificationForResult:cachedNotification];
            
            callback(notifications, nil);
        }
        else callback(nil, nil);
        
        return;
    }
    //////////////////////////////////////////////////////////////////////////////////////////////
    
    NSString *serviceURL = [NSString stringWithFormat:@"%@%@", SERVICE_URL_ROOT, SERVICE_NOTIFICATION];
    
    [RequestHandler getRequestWithURL:serviceURL withCallback:^(id result, NSError *error) {
        
        if (result != nil) {
            BOOL isCached = [HelperClass cacheJsonForData:result withName:CACHE_ID_NOTIFICA];
            
            if (isCached) NSLog(@"Notification Successfully Cached");
            else NSLog(@"Failed Notification Caching");
        }
        else if (result == nil || error) {
            result = [HelperClass getCachedJsonFor:CACHE_ID_NOTIFICA];
            
            NSLog(@"Cached Result: %@", result);
        }
        
        NSMutableArray *notifications = [self parseNotificationForResult:result];
        
        callback(notifications, error);
    }];
}

+ (NSMutableArray *)parseNotificationForResult:(id)notificationResult {
    
    NSMutableArray *parsedNotifications = [[NSMutableArray alloc] init];
    
    [notificationResult enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSDictionary    *notifDict = obj;
        
        Notification *notification = [[Notification alloc] init];
        notification.Id         = notifDict[@"id"];
        notification.message    = notifDict[@"message"];
        notification.timeSend   = notifDict[@"timeSend"];
        
        [parsedNotifications addObject:notification];
        
        notification = nil;
    }];
    
    return parsedNotifications;
}

+ (void)sendEnquiryWithDict:(NSDictionary *)enqDict withCallback:(ResponseCallback)callback {
    
    if ([HelperClass hasNetwork]) {
        NSString *serviceURL = [NSString stringWithFormat:@"%@%@", SERVICE_URL_ROOT, SERVICE_ENQUIRY];
        
        NSLog(@"Service URL : %@", serviceURL);
        
        [RequestHandler postRequestWithURL:serviceURL andDictionary:enqDict withCallback:^(id result, NSError *error) {
            callback(result, error);
        }];
    }
    else {
        [self showAlertWithMessage:ALERT_INTERNET_FAILURE];
        callback(nil, nil);
    }
}

+ (void)searchProductsWithCriteria:(NSString*)searchCriteria withCallback:(ResponseCallback)callback{
    
    
    if ([HelperClass hasNetwork]) {
        NSString *serviceURL = [NSString stringWithFormat:@"%@%@%@", SERVICE_URL_ROOT, SEARCH_PRODUCT,searchCriteria];
        
        NSLog(@"Service URL : %@", serviceURL);
        
        [RequestHandler getRequestWithURL:serviceURL withCallback:^(id result, NSError *error) {
            
            NSMutableArray *products;
            
            if (result != nil) products = [self parseProductForResult:result];
            
            callback(products, error);
        }];
    }
    else {
        [self showAlertWithMessage:ALERT_INTERNET_FAILURE];
        callback(nil, nil);
    }
}

+ (void)sendDeviceToken:(NSString *)deviceToken withCallback:(ResponseCallback)callback {
    
    if ([HelperClass hasNetwork]) {
        NSString *serviceURL = [NSString stringWithFormat:@"%@%@", SERVICE_URL_ROOT, SERVICE_POST_TOKEN];
        
        NSLog(@"Service URL : %@", serviceURL);
        
        NSDictionary *deviceTokenDict = [NSDictionary dictionaryWithObjectsAndKeys:deviceToken, @"deviceId", @"iOS", @"type", nil];
        
        [RequestHandler postRequestWithURL:serviceURL andDictionary:deviceTokenDict withCallback:^(id result, NSError *error) {
            callback(result, error);
        }];
    }
}

+ (void)getFooterTextWithCallback:(ResponseCallback)callback {
    
    /////////////////////////////Handling Offline Mode////////////////////////////////////////////
    if (![HelperClass hasNetwork]) {
        [self showAlertWithMessage:ALERT_INTERNET_FAILURE];
        
        id cachedFooter = [HelperClass getCachedJsonFor:CACHE_ID_FOOTER];
        
        NSLog(@"Cached Footer: %@", cachedFooter);
        
        if (cachedFooter != nil) {
            NSString *footerText = (NSString *)cachedFooter;
            
            callback(footerText, nil);
        }
        else callback(nil, nil);
        
        return;
    }
    //////////////////////////////////////////////////////////////////////////////////////////////
    
    NSString *serviceURL = [NSString stringWithFormat:@"%@%@", SERVICE_URL_ROOT, SERVICE_FOOTER_TXT];
    
    [RequestHandler getStringRequestWithURL:serviceURL withCallback:^(id result, NSError *error) {
        
        if (result != nil) {
            BOOL isCached = [HelperClass cacheJsonForData:result withName:CACHE_ID_FOOTER];
            
            if (isCached) NSLog(@"Footer Successfully Cached");
            else NSLog(@"Footer Notification Caching");
        }
        else if (result == nil || error) {
            result = [HelperClass getCachedJsonFor:CACHE_ID_FOOTER];
            
            NSLog(@"Cached Result: %@", result);
        }
        
        NSString *footerText = (NSString *)result;
        
        if (footerText != nil) callback(footerText, error);
        else callback(nil, nil);
    }];
}

+ (void)showAlertWithMessage:(NSString *)message {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:message delegate:nil cancelButtonTitle:ALERT_OK otherButtonTitles:nil, nil];
    [alert show];
}

+ (NSString *)checkForNSNULL:(NSString *)string {
    
    NSString *str;
    
    if ([string isKindOfClass:[NSNull class]]) str = nil;
    else str = string;
    
    return str;
}

@end
