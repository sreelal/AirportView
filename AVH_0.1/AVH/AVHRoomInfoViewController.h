//
//  AVHRoomInfoViewController.h
//  AVH
//
//  Created by Anamika on 5/26/15.
//  Copyright (c) 2015 Sreelal H. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol AVHRoomInfoViewControllerDelegtae <NSObject>

- (void)didSelectBookingWithDetails:(NSDictionary*)details;

@end

@interface AVHRoomInfoViewController : UIViewController

@property (nonatomic, strong) NSDictionary *hotelDetails;
@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, assign) id<AVHRoomInfoViewControllerDelegtae> delegate;
@end
