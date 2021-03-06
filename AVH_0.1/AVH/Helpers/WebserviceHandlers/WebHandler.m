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
#import "Flight.h"

@implementation WebHandler


+(void)bookRoomNowWithDetails:(NSDictionary*)bookingDetails andResponseCallback:(ResponseCallback)callback{
    
    [RequestHandler postRequestWithURL:HOTELS_BOOKING_URL
                         andDictionary:bookingDetails withCallback:^(id result, NSError *error) {
                             
                             callback(result, error);
                         }];
}

+ (void)getHotelsList:(ResponseCallback)callback{
    
    [RequestHandler getRequestWithURL:HOTELS_LIST withCallback:^(id result, NSError *error) {
        
        if (result != nil) {
            BOOL isCached = [HelperClass cacheJsonForData:result withName:CACHE_ID_PACKAGE];
            
            if (isCached) NSLog(@"Hotels Successfully Cached");
        }
        else if (result == nil || error) {
            result = [HelperClass getCachedJsonFor:CACHE_ID_PACKAGE];
            
            NSLog(@"Cached Result: %@", result);
        }
        
        callback(result, error);
    }];
}

+ (void)getHotelInfoForID:(NSString*)hotelID withCallBack:(ResponseCallback)callback{
    
    
    NSString *urlToLoad = [NSString stringWithFormat:@"%@%@.json",HOTELS_DETAILS,hotelID];
    [RequestHandler getRequestWithURL:urlToLoad withCallback:^(id result, NSError *error) {
        
        if (result != nil) {
            BOOL isCached = [HelperClass cacheJsonForData:result withName:[urlToLoad lastPathComponent]];
            
            if (isCached) NSLog(@"Hotels Successfully Cached");
        }
        else if (result == nil || error) {
            result = [HelperClass getCachedJsonFor:[urlToLoad lastPathComponent]];
            
            NSLog(@"Cached Result: %@", result);
        }
        
        callback(result, error);
    }];
}

+ (void)getWeatherInfoWithCallback:(ResponseCallback)callback{
    
    NSString *url = [NSString stringWithFormat:@"%@/%@/%@/%@?appId=%@&appKey=%@", FLIGHTSTAT_URL_BASE, @"weather/rest/v1/json", WEATHER_PRODUCT, WEATHER_AIRPORT,APP_ID,APP_API_KEY];

    [RequestHandler getRequestWithURL:url withCallback:^(id result, NSError *error) {
        
        if (result != nil) {
            BOOL isCached = [HelperClass cacheJsonForData:result withName:CACHE_ID_WEATHER];
            
            if (isCached) NSLog(@"Category Successfully Cached");
            else NSLog(@"Failed Category Caching");
        }
        else if (result == nil || error) {
            result = [HelperClass getCachedJsonFor:CACHE_ID_WEATHER];
            
            NSLog(@"Cached Result: %@", result);
        }
        
        callback(result, error);
    }];
}

+ (void)getFlightDepInfoWithCallback:(ResponseCallback)callback {
    
    if (![HelperClass hasNetwork]) {
        [self showAlertWithMessage:ALERT_INTERNET_FAILURE];
        
        callback(nil, nil);
        
        return;
    }
    
    //https://api.flightstats.com/flex/flightstatus/rest/v2/json/airport/status/ACC/dep/2015/05/13/16?appId=19d03dee&appKey=747373f943be6a95583ea75765ca8d92&utc=false&numHours=6
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitHour fromDate:[NSDate date]];
    NSInteger day = [components day];
    NSInteger month = [components month];
    NSInteger year = [components year];
    NSInteger hour = [components hour];
    
    NSString *url = [NSString stringWithFormat:@"%@/%@/%@/%@/%ld/%ld/%ld/%ld?appId=%@&appKey=%@&utc=false&numHours=6", FLIGHTSTAT_URL_BASE, @"flightstatus/rest/v2/json", FLIGHT_INFO_API, @"dep", year, month, day, hour, APP_ID,APP_API_KEY];
    
    NSLog(@"Url : %@", url);
    
    [RequestHandler getRequestWithURL:url withCallback:^(id result, NSError *error) {
        
        if (result != nil) {
            id flights = [self parseFlightInfoWithResult:result andIsArrival:NO];
            callback(flights, error);
        }
        else
            callback(result, error);
    }];
}

+ (id)parseFlightInfoWithResult:(NSDictionary *)result andIsArrival:(BOOL)isArrival {
    
    __block NSMutableArray *flights  = [[NSMutableArray alloc] init];
    
    __block NSArray *parsedAirlines = result[@"appendix"][@"airlines"];
    __block NSArray *parsedAirports  = result[@"appendix"][@"airports"];
    NSArray *parsedFlights  = result[@"flightStatuses"];
    
    [parsedFlights enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSDictionary *flightDict = (NSDictionary *)obj;
        Flight *flight = [[Flight alloc] init];
        
        flight.flightCode   = flightDict[@"carrierFsCode"];
        flight.flightNumber = flightDict[@"flightNumber"];
        flight.flightName   = [HelperClass getFilteredObjectValueFromArrOfDictForKey:@"fs" andForValue:flightDict[@"carrierFsCode"] fromDictArr:parsedAirlines forFilterObjKey:@"name"];
        flight.departureAirport  = [HelperClass getFilteredObjectValueFromArrOfDictForKey:@"fs" andForValue:flightDict[@"departureAirportFsCode"] fromDictArr:parsedAirports forFilterObjKey:@"name"];
        flight.arrivalAirport  = [HelperClass getFilteredObjectValueFromArrOfDictForKey:@"fs" andForValue:flightDict[@"arrivalAirportFsCode"] fromDictArr:parsedAirports forFilterObjKey:@"name"];
        flight.departureTime = flightDict[@"departureDate"][@"dateLocal"];
        flight.arrivalTime   = flightDict[@"arrivalDate"][@"dateLocal"];
        
        [flights addObject:flight];
    }];
    
    return flights;
}

+ (NSMutableArray *)parseWeatherInformation:(id)weatherResult {
    
    NSMutableArray *parsedCategories = [[NSMutableArray alloc] init];
    
//    [categoryResult enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//        NSDictionary    *categoryDict = obj;
//        
//        ProductCategory *category = [[ProductCategory alloc] init];
//        category.Id         = categoryDict[@"category_id"];
//        category.name       = categoryDict[@"name"];
//        category.imageURL   = [self checkForNSNULL:categoryDict[@"image"]];
//        category.children   = [categoryDict[@"children"] integerValue];
//        category.sortOrder  = categoryDict[@"sort_order"];
//        
//        [parsedCategories addObject:category];
//        
//        category = nil;
//    }];
    
    return parsedCategories;
}




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
        
        NSDictionary *deviceTokenDict = [NSDictionary dictionaryWithObjectsAndKeys:deviceToken, @"token", @"iOS", @"type", nil];
        
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

+ (void)getHotelInfoListWithCallback:(ResponseCallback)callback {
    
    /////////////////////////////Handling Offline Mode////////////////////////////////////////////
    if (![HelperClass hasNetwork]) {
        [self showAlertWithMessage:ALERT_INTERNET_FAILURE];
        
        id cachedHotelInfo = [HelperClass getCachedJsonFor:CACHE_ID_HOTEL_INFO];
        
        NSLog(@"Cached Hotel Info List: %@", cachedHotelInfo);
        
        if (cachedHotelInfo != nil) {
            NSMutableArray *hotelInfo = cachedHotelInfo[@"infos"];
            
            callback(hotelInfo, nil);
        }
        else callback(nil, nil);
        
        return;
    }
    //////////////////////////////////////////////////////////////////////////////////////////////
    
    NSString *serviceURL = [NSString stringWithFormat:@"%@%@", SERVICE_URL_ROOT, SERVICE_HOTEL_INFO];
    
    [RequestHandler getRequestWithURL:serviceURL withCallback:^(id result, NSError *error) {
        
        if (result != nil) {
            BOOL isCached = [HelperClass cacheJsonForData:result withName:CACHE_ID_HOTEL_INFO];
            
            if (isCached) NSLog(@"HOTEL INFO List Successfully Cached");
            else NSLog(@"Failed HOTEL INFO List Caching");
        }
        else if (result == nil || error) {
            result = [HelperClass getCachedJsonFor:CACHE_ID_HOTEL_INFO];
            
            NSLog(@"Cached Result: %@", result);
        }
        
        NSMutableArray *hotelInfo = result[@"infos"];
        
        callback(hotelInfo, error);
    }];
}

+ (void)getOfferInfoListWithCallback:(ResponseCallback)callback {
    
    /////////////////////////////Handling Offline Mode////////////////////////////////////////////
    if (![HelperClass hasNetwork]) {
        [self showAlertWithMessage:ALERT_INTERNET_FAILURE];
        
        id cachedOfferInfo = [HelperClass getCachedJsonFor:CACHE_ID_OFFER_INFO];
        
        NSLog(@"Cached Offer Info List: %@", cachedOfferInfo);
        
        if (cachedOfferInfo != nil) {
            NSMutableArray *offerInfo = cachedOfferInfo[@"offers"];
            
            callback(offerInfo, nil);
        }
        else callback(nil, nil);
        
        return;
    }
    //////////////////////////////////////////////////////////////////////////////////////////////
    
    NSString *serviceURL = [NSString stringWithFormat:@"%@%@", SERVICE_URL_ROOT, SERVICE_OFFER];
    
    [RequestHandler getRequestWithURL:serviceURL withCallback:^(id result, NSError *error) {
        
        if (result != nil) {
            BOOL isCached = [HelperClass cacheJsonForData:result withName:CACHE_ID_OFFER_INFO];
            
            if (isCached) NSLog(@"Offer INFO List Successfully Cached");
            else NSLog(@"Failed Offer INFO List Caching");
        }
        else if (result == nil || error) {
            result = [HelperClass getCachedJsonFor:CACHE_ID_OFFER_INFO];
            
            NSLog(@"Cached Result: %@", result);
        }
        
        NSMutableArray *offerInfo = result[@"offers"];
        
        callback(offerInfo, error);
    }];
}

+ (void)getPlacesToVisitWithCallback:(ResponseCallback)callback {
    
    /////////////////////////////Handling Offline Mode////////////////////////////////////////////
    if (![HelperClass hasNetwork]) {
        [self showAlertWithMessage:ALERT_INTERNET_FAILURE];
        
        id cachedPlaces = [HelperClass getCachedJsonFor:CACHE_ID_PLACES];
        
        NSLog(@"Cached Places Info List: %@", cachedPlaces);
        
        if (cachedPlaces != nil) {
            NSMutableArray *places = cachedPlaces[@"recommendations"];
            
            callback(places, nil);
        }
        else callback(nil, nil);
        
        return;
    }
    //////////////////////////////////////////////////////////////////////////////////////////////
    
    NSString *serviceURL = [NSString stringWithFormat:@"%@%@", SERVICE_URL_ROOT, SERVICE_PLACES];
    
    [RequestHandler getRequestWithURL:serviceURL withCallback:^(id result, NSError *error) {
        
        if (result != nil) {
            BOOL isCached = [HelperClass cacheJsonForData:result withName:CACHE_ID_PLACES];
            
            if (isCached) NSLog(@"places INFO List Successfully Cached");
            else NSLog(@"Failed Places INFO List Caching");
        }
        else if (result == nil || error) {
            result = [HelperClass getCachedJsonFor:CACHE_ID_PLACES];
            
            NSLog(@"Cached Result: %@", result);
        }
        
        NSMutableArray *places = result[@"recommendations"];
        
        callback(places, error);
    }];
}

+ (void)getGalleryInfoWithCallback:(ResponseCallback)callback {
    
    if (![HelperClass hasNetwork]) {
        [self showAlertWithMessage:ALERT_INTERNET_FAILURE];
        
        /*id cachedPlaces = [HelperClass getCachedJsonFor:CACHE_ID_PLACES];
        
        NSLog(@"Cached Places Info List: %@", cachedPlaces);
        
        if (cachedPlaces != nil) {
            NSMutableArray *places = cachedPlaces[@"recommendations"];
            
            callback(places, nil);
        }
        else callback(nil, nil);*/
        
        return;
    }
    //////////////////////////////////////////////////////////////////////////////////////////////
    
    NSString *serviceURL = [NSString stringWithFormat:@"%@%@", SERVICE_URL_ROOT, SERVICE_GALLERY];
    
    [RequestHandler getRequestWithURL:serviceURL withCallback:^(id result, NSError *error) {
        
        /*if (result != nil) {
            BOOL isCached = [HelperClass cacheJsonForData:result withName:CACHE_ID_PLACES];
            
            if (isCached) NSLog(@"places INFO List Successfully Cached");
            else NSLog(@"Failed Places INFO List Caching");
        }
        else if (result == nil || error) {
            result = [HelperClass getCachedJsonFor:CACHE_ID_PLACES];
            
            NSLog(@"Cached Result: %@", result);
        }*/
        
        NSMutableArray *galleries = result[@"galleries"];
        
        callback(galleries, error);
    }];
}

+ (void)getFacebookProfilewithCallback:(ResponseCallback)callback {
    
    [RequestHandler getRequestWithURL:SERVICE_FACEBOOK_PROF
                         withCallback:^(id result, NSError *error) {
                             
                             callback(result,error);
                         }];
}

+ (void)getFacebookPostswithCallback:(ResponseCallback)callback {
    
    [RequestHandler getRequestWithURL:SERVICE_FACEBOOK_POST
                         withCallback:^(id result, NSError *error) {
                             
                             callback(result,error);
                         }];
}

+ (void)getTripAdvisorReviewswithCallback:(ResponseCallback)callback {
    
    [RequestHandler getRequestWithURL:SERVICE_TA_REVIEWS
                         withCallback:^(id result, NSError *error) {
                             
                             callback(result,error);
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
