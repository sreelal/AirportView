//
//  AOImageView.m
//  AOImageViewDemo
//
//  Created by akria.king on 13-4-2.
//  Copyright (c) 2013年 akria.king. All rights reserved.
//

#import "AOImageView.h"
#import "UrlImageButton.h"
@implementation AOImageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
       
        
    }
    return self;
}

-(id)initWithImageName:(NSString *)imageName title:(NSString *)titleStr x:(float)xPoint y:(float)yPoint height:(float)height width:(float)width
{
    self = [super initWithFrame:CGRectMake(xPoint, yPoint, width, height)];
    if (self) {
        // Initialization code
        UrlImageButton *imageView = [[UrlImageButton alloc]initWithFrame:CGRectMake(0, 0, width, height)];
        //imageView.contentMode = UIViewContentModeScaleAspectFill;
        [imageView setImageFromUrl:YES withUrl:imageName];
        
        [self addSubview:imageView];
    }
    return self;
}
@end
