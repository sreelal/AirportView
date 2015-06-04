//
//  AVHEditRoomCell.m
//  AVH
//
//  Created by Sreelal H on 02/06/15.
//  Copyright (c) 2015 Sreelal H. All rights reserved.
//

#import "AVHEditRoomCell.h"
#import "HelperClass.h"



@interface AVHEditRoomCell () {
    BOOL isLoading;
}

@end

@implementation AVHEditRoomCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)loadHotelImageFrom:(NSString*)imageURL {
    
    
    NSArray *urlSplits = [imageURL componentsSeparatedByString:@"/"];
    NSLog(@"Image Name : %@", [urlSplits lastObject]);
    NSString *imageName = [urlSplits lastObject];
    
    if (imageURL) {
        [HelperClass getCachedImageWithName:imageName withCompletionBlock:^(UIImage *img) {
            [_activityView stopAnimating];
            if (img) {
                self.roomImage.image = img;
                NSLog(@"Cached Image Loaded for %@", imageName);
            }
            else if (!isLoading) {
                isLoading = YES;
                
                [HelperClass loadImageWithURL:imageURL andCompletionBlock:^(UIImage *img, NSData *imgData) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (img) self.roomImage.image = img;
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
        
        [_activityView stopAnimating];
        self.roomImage.image = [UIImage imageNamed:@"no_image.png"];
    }
}


@end
