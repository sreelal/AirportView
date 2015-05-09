//
//  ProductCategory.h
//  DeviceGH
//
//  Created by Sreelash S on 16/12/14.
//  Copyright (c) 2014 Sreelal H. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProductCategory : NSObject

@property (nonatomic, strong) NSString *sortOrder;
@property (nonatomic, strong) NSString *Id;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) NSInteger children;
@property (nonatomic, strong) NSString *imageURL;

@end
