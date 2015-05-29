//
//  AVHImageContainer.m
//  AVH
//
//  Created by Sreelal H on 29/05/15.
//  Copyright (c) 2015 Sreelal H. All rights reserved.
//

#import "AVHImageContainer.h"
#import "HelperClass.h"

@interface AVHImageContainer (){
    
    BOOL isLoading;
}

@property (nonatomic,strong) UIActivityIndicatorView *activity;
@end

@implementation AVHImageContainer

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (void)loadRoomImageWithURL:(NSString *)imageURL {
    
    if (!self.activity) {
        
        self.activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [self addSubview:_activity];
        _activity.center = self.center;
        
    }
    [self.activity setHidesWhenStopped:YES];
    [self.activity setHidden:NO];
    [self.activity startAnimating];
    
    NSArray *urlSplits = [imageURL componentsSeparatedByString:@"/"];
    
    NSLog(@"Image Name : %@", [urlSplits lastObject]);
    
    NSString *imageName = [urlSplits lastObject];
    
    if (imageURL) {
        [HelperClass getCachedImageWithName:imageName withCompletionBlock:^(UIImage *img) {
            if (img) {
                [self.activity stopAnimating];
                self.image = img;
                NSLog(@"Cached Image Loaded for %@", imageName);
            }
            else if (!isLoading) {
                isLoading = YES;
                
                [HelperClass loadImageWithURL:imageURL andCompletionBlock:^(UIImage *img, NSData *imgData) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.activity stopAnimating];
                        if (img) self.image = img;
                    });
                    
                    if (imgData) {
                        BOOL isImageCached = [HelperClass cacheImageWithData:imgData withName:imageName];
                        
                        if (isImageCached) NSLog(@"%@ Image Cached", imageName);
                        else NSLog(@"%@ Image Not Cached", imageName);
                    }
                    
                    isLoading = NO;
                }];
            }
        }];
    }
    else {
        [self.activity stopAnimating];
        self.image = [UIImage imageNamed:@"no_image.png"];
    }
}

@end
