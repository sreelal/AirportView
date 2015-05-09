//
//  RequestHandler.h
//  DMT
//
//  Created by Sreelash S on 10/08/14.
//  Copyright (c) 2014 Sreelash S. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "JSON.h"

@interface RequestHandler : NSObject {
    
}

+ (void)getRequestWithURL:(NSString *)url withCallback:(void (^) (id result, NSError *error))callbackHandler;
+ (void)getStringRequestWithURL:(NSString *)url withCallback:(void (^) (id result, NSError *error))callbackHandler;
+ (void)postRequestWithURL:(NSString *)url andDictionary:(NSDictionary *)dataDict withCallback:(void (^) (id result, NSError *error))callbackHandler;

@end
