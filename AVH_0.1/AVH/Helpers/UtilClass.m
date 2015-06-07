//
//  UtilClass.m
//  Samsfirma
//
//  Created by Sreelash S on 26/04/15.
//  Copyright (c) 2015 Sreelal H. All rights reserved.
//

#import "UtilClass.h"

static NSInteger activeMenuIndex;

@implementation UtilClass

+ (id)sharedManager {
    
    static UtilClass *sharedInstance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

#pragma mark - Getters & Setters

- (void)setActiveMenuIndex:(NSInteger)index {
    activeMenuIndex = index;
}

- (NSInteger)getActiveMenuIndex {
    return activeMenuIndex;
}

@end
