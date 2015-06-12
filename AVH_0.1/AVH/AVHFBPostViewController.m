//
//  CGFBPostViewController.m
//  CompuGhana
//
//  Created by Sreelash S on 15/03/15.
//  Copyright (c) 2015 Sreelal H. All rights reserved.
//

#import "AVHFBPostViewController.h"
#import "Helpers/HelperClass.h"
//#import <FacebookSDK/FacebookSDK.h>
#import "FBTableViewCell.h"

@interface AVHFBPostViewController ()

//@property (nonatomic, strong) FBLikeControl *fbPostLike;
@property (nonatomic, strong) NSArray *comments;
@end

@implementation AVHFBPostViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *leftBarItem = [HelperClass getBackButtonItemWithTarget:self andAction:@selector(navgationBackClicked:)];
    leftBarItem.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = leftBarItem;
    
    postTableView.rowHeight = UITableViewAutomaticDimension;
    postTableView.estimatedRowHeight = 0.0;
    
    [self updateUIWithPost];
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
//    if ([HelperClass validFBSessionExists]){
//        //if (FBSession.activeSession.state == FBSessionStateCreatedTokenLoaded) {
//        NSLog(@"Found a cached session");
//        [_fbPostLike setHidden:NO];
//    }
//    else{
//        [_fbPostLike setHidden:YES];
//    }
}

- (void)navgationBackClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - UI Updates

- (void)updateUIWithPost {
    
    NSString *message = _fbPostDict[@"message"];
    message = (message.length>0)?message:_fbPostDict[@"story"];

    NSArray *likes = _fbPostDict[@"likes"][@"data"];
    _comments = _fbPostDict[@"comments"][@"data"];
    NSString *imagURL = _fbPostDict[@"picture"];
    
    NSString *postId = _fbPostDict[@"id"];
    
    postCommentsAndLikesLabel.text = [NSString stringWithFormat:@"%lu Comments %lu Likes", _comments.count, likes.count];
    
    if (imagURL) {
        [HelperClass loadImageWithURL:imagURL andCompletionBlock:^(UIImage *img, NSData *imgData) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (img) {
                    postImageView.image = img;
                }
            });
        }];
    }
    
    postTextView.textColor = [HelperClass colorFromHexString:APP_THEME];
    postTextView.text = message;
    
    if (_comments.count) {
        [postTableView reloadData];
    }
    else {
        postTextView.frame = CGRectMake(postTextView.frame.origin.x, postTextView.frame.origin.y, postTextView.frame.size.width, postTextView.frame.size.height + 150);
        [postTableView setHidden:YES];
    }
    
//    self.fbPostLike = [[FBLikeControl alloc] init];
//    self.fbPostLike.objectID = postId;
//    self.fbPostLike.frame = CGRectMake(3, 67, self.fbPostLike.frame.size.width, self.fbPostLike.frame.size.height);
//    self.fbPostLike.likeControlStyle = FBLikeControlStyleStandard;
//    self.fbPostLike.foregroundColor = [HelperClass colorFromHexString:APP_THEME];
//    [self.view addSubview:self.fbPostLike];
}

#pragma mark - TableView Delegates

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    
    return [_comments count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *fbDataCellId = @"fbCell";
    FBTableViewCell *tableCell = [tableView dequeueReusableCellWithIdentifier:fbDataCellId];
    
    NSString *message = _comments[indexPath.row][@"message"];
    NSString *commentFrom = _comments[indexPath.row][@"from"][@"name"];
    NSString *likeCount = [NSString stringWithFormat:@"%@ Likes", _comments[indexPath.row][@"like_count"]];
    
    tableCell.postText.text = message;
    tableCell.likesText.text = likeCount;
    tableCell.commentsText.text = commentFrom;
    
    if (indexPath.row % 2 == 0) {
        [tableCell setBlueTheme];
    }
    else{
        [tableCell setWhiteTheme];
    }
    
    //tableCell.iconImage.image = nil;
    [tableCell.activityView setHidden:YES];
    
    tableCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return tableCell;
}

@end
