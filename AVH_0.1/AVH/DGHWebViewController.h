//
//  DGHWebViewController.h
//  DeviceGH
//
//  Created by Sreelash S on 27/01/15.
//  Copyright (c) 2015 Sreelal H. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DGHWebViewController : UIViewController {
    
    IBOutlet UIWebView *webView;
}

@property (nonatomic, strong) NSString *viewTitle;

@end
