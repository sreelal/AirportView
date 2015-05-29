//
//  AVHHotelCellTableViewCell.m
//  AVH
//
//  Created by Sreelal  Hamsavahanan on 25/05/15.
//  Copyright (c) 2015 Sreelal H. All rights reserved.
//

#import "AVHHotelCellTableViewCell.h"
#import "HelperClass.h"

@interface AVHHotelCellTableViewCell () {
    BOOL isLoading;
}

@end

@implementation AVHHotelCellTableViewCell

- (void)awakeFromNib {
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

- (void)loadRoomImageWithURL:(NSString *)imageURL {
    
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
                self.hotelImage.image = img;
                NSLog(@"Cached Image Loaded for %@", imageName);
            }
            else if (!isLoading) {
                isLoading = YES;
                
                [HelperClass loadImageWithURL:imageURL andCompletionBlock:^(UIImage *img, NSData *imgData) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.activity stopAnimating];
                        if (img) self.hotelImage.image = img;
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
        self.hotelImage.image = [UIImage imageNamed:@"no_image.png"];
    }
}
- (IBAction)onMoreInfo:(id)sender {
    
    
}

- (IBAction)onBookHotel:(id)sender {
    
}
@end
