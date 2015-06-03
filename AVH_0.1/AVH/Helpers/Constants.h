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
#define HOTELS_LIST @"http://demo.airportviewhotel.net/package.json"
#define HOTELS_DETAILS @"http://demo.airportviewhotel.net/package/view/"

#define SERVICE_URL_ROOT     @"http://demo.airportviewhotel.net/"
#define SERVICE_HOTEL_INFO   @"hotel_info/all.json"
#define SERVICE_OFFER        @"offer.json"
#define SERVICE_CATEGORY     @"category"
#define SERVICE_SUB_CATEGORY @"category&parent="
#define SERVICE_PRODUCT      @"product&path="
#define SERVICE_PRODUCT_INFO @"product/info&product="
#define SERVICE_BANNER       @"banner&banner=7"
#define SERVICE_POST_TOKEN   @"device/register"
#define SERVICE_NOTIFICATION @"notification"
#define SERVICE_ENQUIRY      @"enquiry/submit"
#define SEARCH_PRODUCT       @"product/search&search="
#define SERVICE_FOOTER_TXT   @"status/text"
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
#define DATE_FORMAT_MM_DD_YYYY @"dd/MM/yyyy"

#define CacheDirectory     [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0]
#define DocumentsDirectory [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]



#define YOUR_STAY_INFO        @"yourstayinformation"
#define ROOM_RATES_INFO       @"roomratesinformation"
#define GUEST_DETAILS         @"guestinformation"

