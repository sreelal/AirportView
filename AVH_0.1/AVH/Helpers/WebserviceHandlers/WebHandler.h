//
//  RequestHandler.h
//  DMT
//
//  Created by Sreelash S on 10/08/14.
//  Copyright (c) 2014 Sreelash S. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RequestHandler.h"

typedef void (^ResponseCallback) (id object, NSError *error);

@interface WebHandler : NSObject {
    
}

+ (void)getCategoriesWithCallback:(ResponseCallback)callback;
+ (void)getBannerImagesWithCallback:(ResponseCallback)bannerImagesCallback;
+ (void)getSubCategoriesForCategoryId:(NSString *)categoryId withCallback:(ResponseCallback)callback;
+ (void)getProductsForCategoryId:(NSString *)categoryId withCallback:(ResponseCallback)callback;
+ (void)getProductInfoWithId:(NSString *)productId withCallback:(ResponseCallback)callback;
+ (void)sendDeviceToken:(NSString *)deviceToken withCallback:(ResponseCallback)callback;
+ (void)getNotificationsWithCallback:(ResponseCallback)callback;
+ (void)sendEnquiryWithDict:(NSDictionary *)enqDict withCallback:(ResponseCallback)callback;
+ (void)searchProductsWithCriteria:(NSString*)searchCriteria withCallback:(ResponseCallback)callback;
+ (void)getFooterTextWithCallback:(ResponseCallback)callback;
@end
