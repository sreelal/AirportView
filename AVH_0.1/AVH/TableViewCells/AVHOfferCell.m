//
//  AVHOfferCell.m
//  AVH
//
//  Created by Sreelash S on 31/05/15.
//  Copyright (c) 2015 Sreelal H. All rights reserved.
//

#import "AVHOfferCell.h"
#import "HelperClass.h"

@interface AVHOfferCell () {
    BOOL isLoading;
}

@end

@implementation AVHOfferCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)loadInfoImageWithURL:(NSString *)imageURL {
    
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
                self.infoImage.image = img;
                NSLog(@"Cached Image Loaded for %@", imageName);
            }
            else if (!isLoading) {
                isLoading = YES;
                
                [HelperClass loadImageWithURL:imageURL andCompletionBlock:^(UIImage *img, NSData *imgData) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.activity stopAnimating];
                        if (img) self.infoImage.image = img;
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
        self.infoImage.image = [UIImage imageNamed:@"no_image.png"];
    }
}

@end
