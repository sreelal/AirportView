//
//  Constants.h
//  DeviceGH
//
//  Created by Sreelash S on 15/12/14.
//  Copyright (c) 2014 Sreelal H. All rights reserved.
//

#ifndef DeviceGH_Constants_h
#define DeviceGH_Constants_h


#endif

//------------------Webservice----------------------
#define FLIGHTSTAT_URL_BASE     @"https://api.flightstats.com/flex"
#define APP_ID  @"19d03dee"
//#define APP_API_KEY  @"747373f943be6a95583ea75765ca8d92"
#define APP_API_KEY @"02ce533ec3c3ab03bdc0518f4d06ddf9"
#define FLIGHT_INFO_API   @"airport/status/ACC"
#define WEATHER_PRODUCT @"metar"
#define WEATHER_AIRPORT @"ACC"


#define HOTELS_LIST          @"http://www.airportviewhotel.net/package.json"
#define HOTELS_DETAILS       @"http://www.airportviewhotel.net/package/view/"
#define HOTELS_BOOKING_URL   @"http://www.airportviewhotel.net/booking/confirm"
#define SERVICE_URL_ROOT     @"http://www.airportviewhotel.net/"
#define SERVICE_HOTEL_INFO   @"hotel_info/all.json"
#define SERVICE_PLACES       @"recommendation/all.json"
#define SERVICE_GALLERY      @"gallery.json"
#define SERVICE_OFFER        @"offer.json"
#define SERVICE_CATEGORY     @"category"
#define SERVICE_SUB_CATEGORY @"category&parent="
#define SERVICE_PRODUCT      @"product&path="
#define SERVICE_PRODUCT_INFO @"product/info&product="
#define SERVICE_BANNER       @"banner&banner=7"
#define SERVICE_POST_TOKEN   @"device/register"
#define SERVICE_NOTIFICATION @"notification"
#define SERVICE_ENQUIRY      @"contact/submit1"
#define SEARCH_PRODUCT       @"product/search&search="
#define SERVICE_FOOTER_TXT   @"status/text"

#define SERVICE_FACEBOOK_POST   @"https://graph.facebook.com/379712298860476/posts?access_token=CAAW130Rdz50BAPFGQMDKTlyZAqsOZA20dRqbvwRPZC2rVqjhXZCOpo3XDVPzxsOcz3IaXqq6kFlJZC5itIRv2uwEWpPQUmXZBRmrJfSf03C3UeKq7NRAVKCSKvdAN5sVjYI1HLyVFDd9shcJ8z0mUerisUhLDWc8sT7Ixq2ePS3rI6ldEgsuLJqvlLcv350vvA2rScOqAGSrz2V9vrGJWf"
#define SERVICE_FACEBOOK_PROF   @"https://graph.facebook.com/379712298860476?access_token=CAAW130Rdz50BAPFGQMDKTlyZAqsOZA20dRqbvwRPZC2rVqjhXZCOpo3XDVPzxsOcz3IaXqq6kFlJZC5itIRv2uwEWpPQUmXZBRmrJfSf03C3UeKq7NRAVKCSKvdAN5sVjYI1HLyVFDd9shcJ8z0mUerisUhLDWc8sT7Ixq2ePS3rI6ldEgsuLJqvlLcv350vvA2rScOqAGSrz2V9vrGJWf"
#define SERVICE_FB_PAGE_IMG_URL @"https://graph.facebook.com/379712298860476/picture"
#define SERVICE_TA_REVIEWS      @"http://api.tripadvisor.com/api/partner/2.0/location/628036?key=3b3231dd42374bb5abc5fa46d55218e4"
//--------------------------------------------------

//------------------Dictionary Keys-----------------
#define CATEGORY_ID @"category_id"
#define NAME @"name"
#define CHILDREN @"children"
#define IMAGE @"image"
#define SORT_ORDER @"sort_order"
#define KEY_ENQUIRE_PRODUCTS @"enquire_products"
#define KEY_DEVICE_TOKEN     @"DeviceToken"
#define KEY_FOOTER           @"Footer"
//--------------------------------------------------

//-----------------Soryboard Ids--------------------
#define STORYBOARD_ID_MENUVC @"leftMenuViewController"
//--------------------------------------------------

//-----------------Notification Names---------------
#define NOTIFICATION_REFRESH_MENU @"refresh left menu"
//--------------------------------------------------

//-----------------TableViewCell Identifiers----------
#define CELL_ID_MENU_HEADER   @"MenuHeader"
#define CELL_ID_SUB_MENU      @"SubMenu"
#define CELL_ID_NOTIFICATION  @"NotificationCell"
//----------------------------------------------------

//-----------------Helper Class Constants-------------
#define CACHE_ID_PACKAGE      @"package.json"
#define CACHE_ID_SUB_CATEGORY @"Category_"
#define CACHE_ID_CATEGORY_PRO @"Category_Product_"
#define CACHE_ID_PRODUCT      @"Product_"
#define CACHE_ID_CATEGORY     @"Category.json"
#define CACHE_ID_HOTEL_INFO   @"Hotel_Info.json"
#define CACHE_ID_OFFER_INFO   @"Offer_Info.json"
#define CACHE_ID_PLACES       @"Places_To_Visit.json"
#define CACHE_ID_FLIGHT_DEP   @"Departure.json"
#define CACHE_ID_WEATHER      @"Weather.json"
#define CACHE_ID_NOTIFICA     @"Notification.json"
#define CACHE_ID_BANNER       @"Banner.json"
#define CACHE_ID_EXTENSION    @".json"
#define CACHE_ID_FOOTER       @"Footer.txt"
//----------------------------------------------------

//-----------------------Alert Messages---------------
#define ALERT_OK @"OK"
#define ALERT_INTERNET_FAILURE @"Network not available."
#define ALERT_NO_SEARCH_RESULT @"No products found with the given search key."
//----------------------------------------------------

//-----------------------View Titles------------------
#define VIEW_TITLE_ABOUT   @"About Us"
#define VIEW_TITLE_WEEKLY  @"Weekly Promotions"
#define VIEW_TITLE_MONTHLY @"Monthly Promotions"
//----------------------------------------------------

#define SELECT_DATE @"Select Date"
#define DATE_FORMAT_MM_DD_YYYY @"yyyy-MM-dd"

#define CacheDirectory     [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0]
#define DocumentsDirectory [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]

#define APP_THEME     @"#66BFE8"

#define YOUR_STAY_INFO        @"yourstayinformation"
#define ROOM_RATES_INFO       @"roomratesinformation"
#define GUEST_DETAILS         @"guestinformation"
