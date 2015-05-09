//
//  Product.m
//  DeviceGH
//
//  Created by Sreelash S on 19/01/15.
//  Copyright (c) 2015 Sreelal H. All rights reserved.
//

#import "Product.h"

@implementation Product
@synthesize Id, name, imageURL;

- (void)encodeWithCoder:(NSCoder *)coder;
{
    [coder encodeObject:Id forKey:@"Id"];
    [coder encodeObject:name forKey:@"name"];
    [coder encodeObject:imageURL forKey:@"imageURL"];
}

- (id)initWithCoder:(NSCoder *)coder;
{
    self = [super init];
    
    if (self != nil) {
        Id = [coder decodeObjectForKey:@"Id"];
        name = [coder decodeObjectForKey:@"name"];
        imageURL = [coder decodeObjectForKey:@"imageURL"];
    }
    
    return self;
}

@end
