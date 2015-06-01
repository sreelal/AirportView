//
//  AVHDataHandler.m
//  AVH
//
//  Created by Sreelal H on 01/06/15.
//  Copyright (c) 2015 Sreelal H. All rights reserved.
//

#import "AVHDataHandler.h"

@implementation AVHDataHandler

+ (id)sharedManager {
    static AVHDataHandler *sharedAVHDataHandler = nil;
    @synchronized(self) {
        if (sharedAVHDataHandler == nil)
            sharedAVHDataHandler = [[self alloc] init];
    }
    return sharedAVHDataHandler;
}


@end
