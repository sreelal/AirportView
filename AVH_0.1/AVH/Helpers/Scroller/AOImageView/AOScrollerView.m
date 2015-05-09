//
//  AOScrollerView.m
//  AOImageViewDemo
//
//  Created by akria.king on 13-4-2.
//  Copyright (c) 2013年 akria.king. All rights reserved.
//

#import "AOScrollerView.h"
//#define WIDTH 320
@implementation AOScrollerView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
//自定义实例化方法

-(id)initWithNameArr:(NSMutableArray *)imageArr titleArr:(NSMutableArray *)titleArr height:(float)heightValue width:(float)widthValue{
    self=[super initWithFrame:CGRectMake(0, 0, widthValue, heightValue)];
    if (self) {
        page=0;//设置当前页为1
        
        imageNameArr = imageArr;
        titleStrArr=titleArr;
        //图片总数
        NSUInteger imageCount = [imageNameArr count];
        imageSV = [[UIScrollView alloc]initWithFrame:self.bounds];
        
        imageSV.directionalLockEnabled = YES;
        imageSV.pagingEnabled = YES;
        
        imageSV.showsVerticalScrollIndicator = NO;
        imageSV.showsHorizontalScrollIndicator = NO;
        
        CGSize newSize = CGSizeMake(widthValue * imageCount,  imageSV.frame.size.height);
        [imageSV setContentSize:newSize];
        [self addSubview:imageSV];
        //*********************************
        for (int i=0; i<imageCount; i++) {
            NSString *str = @"";
            if (i<titleStrArr.count) {
                
                str=[titleStrArr objectAtIndex:i];
            }
            AOImageView *imageView = [[AOImageView alloc]initWithImageName:[imageArr objectAtIndex:i]
                                                                     title:str
                                                                         x:widthValue*i
                                                                         y:0
                                                                    height:imageSV.frame.size.height
                                                                     width:widthValue];
            imageView.uBdelegate=self;
            imageView.tag=i;
            imageView.frame=CGRectMake(imageView.frame.origin.x, 0, imageView.frame.size.width, imageView.frame.size.height);
            [imageSV addSubview:imageView];
        }

       [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(changeView) userInfo:nil repeats:YES];
        
        
    }
    return self;
}
//NSTimer方法
-(void)changeView
{
    //修改页码
    if (page == 0) {
        switchDirection = rightDirection;
    }else if(page == imageNameArr.count-1){
        switchDirection = leftDirection;
    }
    if (switchDirection == rightDirection) {
        page ++;
    }else if (switchDirection == leftDirection){
        page --;
    }

    //page++;
//    //判断是否大于上线
//    if (page==imageNameArr.count) {
//        //重置页码
//        page=0;
//    }
    //设置滚动到第几页
    [imageSV setContentOffset:CGPointMake(self.frame.size.width*page, 0) animated:YES];
    
    
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
#pragma UBdelegate
-(void)click:(int)vid{
    //调用委托实现方法
    [self.vDelegate buttonClick:vid];
}
@end
