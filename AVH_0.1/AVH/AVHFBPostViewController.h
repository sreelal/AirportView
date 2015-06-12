//
//  CGFBPostViewController.h
//  CompuGhana
//
//  Created by Sreelash S on 15/03/15.
//  Copyright (c) 2015 Sreelal H. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AVHFBPostViewController : UIViewController {
    IBOutlet UIImageView *postImageView;
    IBOutlet UILabel *postCommentsAndLikesLabel;
    IBOutlet UITextView *postTextView;
    IBOutlet UITableView *postTableView;
}

@property (nonatomic, strong) NSDictionary *fbPostDict;

@end
