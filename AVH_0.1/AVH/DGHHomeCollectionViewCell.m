//
//  DGHHomeCollectionViewCell.m
//  DeviceGH
//
//  Created by Sreelash S on 21/12/14.
//  Copyright (c) 2014 Sreelal H. All rights reserved.
//

#import "DGHHomeCollectionViewCell.h"
#import "HelperClass.h"

@interface DGHHomeCollectionViewCell () {
    BOOL isLoading;
}

@end

@implementation DGHHomeCollectionViewCell

- (void)setBounds:(CGRect)bounds {
    [super setBounds:bounds];
    self.contentView.frame = bounds;
}

- (void)setupBg {
    
    /*CALayer *borderLayer = [CALayer layer];
    CGRect borderFrame = CGRectMake(0, 0, (self.imageView.frame.size.width), (self.imageView.frame.size.height));
    [borderLayer setBackgroundColor:[[UIColor clearColor] CGColor]];
    [borderLayer setFrame:borderFrame];
    [borderLayer setCornerRadius:5.0];
    [borderLayer setBorderWidth:1.0];
    [borderLayer setBorderColor:[[UIColor lightGrayColor] CGColor]];
    [self.imageView.layer addSublayer:borderLayer];*/
    
    [self.imageView.layer setCornerRadius:5.0];
    [self.imageView.layer setBorderWidth:1.0];
    [self.imageView.layer setBorderColor:[[UIColor lightGrayColor] CGColor]];
}

- (void)loadCategoryImageForCategory:(ProductCategory *)category {
    
    
    NSString *imageURL = category.imageURL;
    NSArray *urlSplits = [imageURL componentsSeparatedByString:@"/"];
    
    NSLog(@"Image Name : %@", [urlSplits lastObject]);
    //NSString *imageName = [NSString stringWithFormat:@"%@_%@", category.name, category.Id];
    NSString *imageName = [urlSplits lastObject];
    
    if (imageURL) {
        [HelperClass getCachedImageWithName:imageName withCompletionBlock:^(UIImage *img) {
            if (img) {
                self.imageView.image = img;
                NSLog(@"Cached Image Loaded for %@", imageName);
            }
            else if (!isLoading) {
                isLoading = YES;
                
                [HelperClass loadImageWithURL:imageURL andCompletionBlock:^(UIImage *img, NSData *imgData) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (img) self.imageView.image = img;
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
        self.imageView.image = [UIImage imageNamed:@"no_image.png"];
    }
}

@end
