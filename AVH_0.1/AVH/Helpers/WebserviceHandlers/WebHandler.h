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
+ (void)getHotelsList:(ResponseCallback)callback;
+ (void)getWeatherInfoWithCallback:(ResponseCallback)callback;
+ (void)getFlightDepInfoWithCallback:(ResponseCallback)callback;
+ (void)getHotelInfoForID:(NSString*)hotelID withCallBack:(ResponseCallback)callback;
+ (void)getHotelInfoListWithCallback:(ResponseCallback)callback;
+ (void)getOfferInfoListWithCallback:(ResponseCallback)callback;
+ (void)getPlacesToVisitWithCallback:(ResponseCallback)callback;
+ (void)getFacebookProfilewithCallback:(ResponseCallback)callback;
+ (void)getFacebookPostswithCallback:(ResponseCallback)callback;
+ (void)getTripAdvisorReviewswithCallback:(ResponseCallback)callback;
+ (void)getCategoriesWithCallback:(ResponseCallback)callback;
+ (void)getBannerImagesWithCallback:(ResponseCallback)bannerImagesCallback;
+ (void)getSubCategoriesForCategoryId:(NSString *)categoryId withCallback:(ResponseCallback)callback;
+ (void)getGalleryInfoWithCallback:(ResponseCallback)callback;
+ (void)getProductsForCategoryId:(NSString *)categoryId withCallback:(ResponseCallback)callback;
+ (void)getProductInfoWithId:(NSString *)productId withCallback:(ResponseCallback)callback;
+ (void)sendDeviceToken:(NSString *)deviceToken withCallback:(ResponseCallback)callback;
+ (void)getNotificationsWithCallback:(ResponseCallback)callback;
+ (void)sendEnquiryWithDict:(NSDictionary *)enqDict withCallback:(ResponseCallback)callback;
+ (void)searchProductsWithCriteria:(NSString*)searchCriteria withCallback:(ResponseCallback)callback;
+ (void)getFooterTextWithCallback:(ResponseCallback)callback;
+(void)bookRoomNowWithDetails:(NSDictionary*)bookingDetails andResponseCallback:(ResponseCallback)callback;
@end
