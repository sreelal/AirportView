//
//  UtilClass.h
//  Samsfirma
//
//  Created by Sreelash S on 26/04/15.
//  Copyright (c) 2015 Sreelal H. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UtilClass : NSObject

+ (id)sharedManager;

- (void)setActiveMenuIndex:(NSInteger)index;

- (NSInteger)getActiveMenuIndex;

@end
