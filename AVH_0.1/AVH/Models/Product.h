//
//  Product.h
//  DeviceGH
//
//  Created by Sreelash S on 19/01/15.
//  Copyright (c) 2015 Sreelal H. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Product : NSObject

@property (nonatomic, strong) NSString *Id;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *imageURL;

- (id)initWithCoder:(NSCoder *)coder;
- (void)encodeWithCoder:(NSCoder *)coder;

@end
