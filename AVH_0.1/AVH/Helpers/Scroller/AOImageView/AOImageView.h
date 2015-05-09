//
//  AOImageView.h
//  AOImageViewDemo
//
//  Created by akria.king on 13-4-2.
//  Copyright (c) 2013年 akria.king. All rights reserved.
//

#import <UIKit/UIKit.h>
//按钮点击协议
@protocol UrLImageButtonDelegate <NSObject>

-(void)click:(int)vid;

@end


@interface AOImageView : UIView
@property(nonatomic,strong)id<UrLImageButtonDelegate> uBdelegate;

-(id)initWithImageName:(NSString *)imageName title:(NSString *)titleStr x:(float)xPoint y:(float)yPoint height:(float)height width:(float)width;
@end
