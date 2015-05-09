//
//  DGHProductCell.m
//  DeviceGH
//
//  Created by Sreelash S on 20/01/15.
//  Copyright (c) 2015 Sreelal H. All rights reserved.
//

#import "DGHProductCell.h"
#import "HelperClass.h"

@interface DGHProductCell () {
    BOOL isLoading;
}

@property (nonatomic, strong) Product *product;

@end

@implementation DGHProductCell

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
    
    [self.enquiryBtn addTarget:self action:@selector(addToInquireClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.infoBtn addTarget:self action:@selector(goToProductInfo) forControlEvents:UIControlEventTouchUpInside];
    
    [self.removeBtn addTarget:self action:@selector(removeProductClicked) forControlEvents:UIControlEventTouchUpInside];
}

- (void)loadProductImageForProduct:(Product *)product {
    
    self.product = product;
    
    [self.activity setHidesWhenStopped:YES];
    [self.activity setHidden:NO];
    [self.activity startAnimating];
    
    NSString *imageURL = product.imageURL;
    NSArray *urlSplits = [imageURL componentsSeparatedByString:@"/"];
    NSString *imageName = [urlSplits lastObject];
    
    NSLog(@"Image Name : %@", [urlSplits lastObject]);
    //NSString *imageName = [NSString stringWithFormat:@"%@_%@", product.name, product.Id];
    
    if (imageURL) {
        [HelperClass getCachedImageWithName:imageName withCompletionBlock:^(UIImage *img) {
            if (img) {
                [self.activity stopAnimating];
                self.imageView.image = img;
                NSLog(@"Cached Image Loaded for %@", imageName);
            }
            else if (!isLoading) {
                isLoading = YES;
                
                [HelperClass loadImageWithURL:imageURL andCompletionBlock:^(UIImage *img, NSData *imgData) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.activity stopAnimating];
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
        [self.activity stopAnimating];
        self.imageView.image = [UIImage imageNamed:@"no_image.png"];
    }
}

- (void)addToInquireClicked {
    
    if ([self.delegate respondsToSelector:@selector(addProductToEnquireList:)]) {
        [self.delegate addProductToEnquireList:self.product];
    }
}

- (void)removeProductClicked {
    
    if ([self.delegate respondsToSelector:@selector(deleteProductFromEnquireList:)]) {
        [self.delegate deleteProductFromEnquireList:self.product];
    }
}

- (void)goToProductInfo {
    
    if ([self.delegate respondsToSelector:@selector(viewProductInfo:)]) {
        [self.delegate viewProductInfo:self.product];
    }
}

@end
