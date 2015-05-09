//
//  RequestHandler.m
//  DMT
//
//  Created by Sreelash S on 10/08/14.
//  Copyright (c) 2014 Sreelash S. All rights reserved.
//

#import "RequestHandler.h"

static NSOperationQueue *reqQueue;

@implementation RequestHandler

+ (NSOperationQueue *)requestQueue
{
    if (!reqQueue) {
        reqQueue = [[NSOperationQueue alloc] init];
    }
    
    return reqQueue;
}

+ (void)getRequestWithURL:(NSString *)url withCallback:(void (^) (id result, NSError *error))callbackHandler {
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[self requestQueue] completionHandler:^(NSURLResponse *resp, NSData *data, NSError *error) {
        
        id  responseObject = nil;
        
        if (data != nil) {
            responseObject = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        }
        
        NSLog(@"Response : %@", responseObject);
        
        callbackHandler(responseObject, error);
    }];
}

+ (void)getStringRequestWithURL:(NSString *)url withCallback:(void (^) (id result, NSError *error))callbackHandler {
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[self requestQueue] completionHandler:^(NSURLResponse *resp, NSData *data, NSError *error) {
        
        id  responseObject = nil;
        
        if (data != nil) {
            responseObject = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
        }
        
        NSLog(@"Response : %@", responseObject);
        
        callbackHandler(responseObject, error);
    }];
}

+ (void)postRequestWithURL:(NSString *)url andDictionary:(NSDictionary *)dataDict withCallback:(void (^) (id result, NSError *error))callbackHandler {
    
    //NSString *jsonRequest = [dataDict JSONRepresentation];
    NSString *jsonRequest = [RequestHandler getJSONStringForArrOrDict:dataDict];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    NSData *requestData = [NSData dataWithBytes:[jsonRequest UTF8String] length:[jsonRequest length]];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%d", [requestData length]] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody: requestData];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[self requestQueue] completionHandler:^(NSURLResponse *resp, NSData *data, NSError *error) {
                
        id  responseObject = nil;
        
        if (data != nil) {
            responseObject = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        }        
        
        NSLog(@"Response : %@", responseObject);
        
        callbackHandler(responseObject, error);        
    }];
}

+ (NSString *)getJSONStringForArrOrDict:(id)obj {
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:obj
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    NSString *jsonString = nil;
    
    if (! jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSLog(@"json string : %@", jsonString);
    }
    
    return jsonString;
}

@end
