//
//  CGHFaceBookViewController.m
//  CompuGhana
//
//  Created by Sreelal H on 11/02/15.
//  Copyright (c) 2015 Sreelal H. All rights reserved.
//

#import "AVHFaceBookViewController.h"
#import "HelperClass.h"
//#import <FacebookSDK/FacebookSDK.h>
#import "WebHandler.h"
#import "FBTableViewCell.h"
#import "AppDelegate.h"
#import "AVHFBPostViewController.h"

@interface AVHFaceBookViewController ()

//@property (nonatomic, strong) FBSession *session;
@property (nonatomic, strong) NSDictionary *fbData;
@property (weak, nonatomic) IBOutlet UITableView *tableCollection;
@property (strong ,nonatomic) NSMutableDictionary *cachedImages;

@property (nonatomic, assign) BOOL isViewPopped;

//@property (strong ,nonatomic) FBLikeControl *fbLike;
@property (strong ,nonatomic) UIButton   *fbLoginbutton;

@end

@implementation AVHFaceBookViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"AVH_logo.png"]];
    
    UIBarButtonItem *leftBarItem = [HelperClass getBackButtonItemWithTarget:self andAction:@selector(navgationBackClicked:)];
    leftBarItem.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = leftBarItem;
    
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    
     self.cachedImages = [[NSMutableDictionary alloc] init];
    
    [self.fbPageImage setClipsToBounds:YES];
    [self.fbPageImage.layer setCornerRadius:5.0];
    [self.fbPageImage.layer setBorderWidth:1.0];
    [self.fbPageImage.layer setBorderColor:[[UIColor lightGrayColor] CGColor]];
    
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:[HelperClass getRightBarButtonItemTextAttributes] forState:UIControlStateNormal];
    
    [HelperClass loadImageWithURL:SERVICE_FB_PAGE_IMG_URL andCompletionBlock:^(UIImage *img, NSData *imgData) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (img) {
                self.fbPageImage.image = img;
            }
        });
    }];
    
    [WebHandler getFacebookProfilewithCallback:^(id object, NSError *error) {
        if (!error) {
            NSDictionary *fbProfileDict = (NSDictionary*)object;
            
            [self updateFBProfileOnUI:fbProfileDict];
        }
    }];
    
    _tableCollection.rowHeight = UITableViewAutomaticDimension;
    _tableCollection.estimatedRowHeight = 0.0;
    
    
    //[self showFBLikeButton];

}

/*- (void)showFBLoginButton{

    if (!self.fbLoginButton) {
        
        self.fbLoginButton = [UIButton buttonWithType:UIButtonTypeCustom];
        //_fbLoginbutton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        self.fbLoginButton.frame = CGRectMake(self.fbLike.frame.origin.x+self.fbLike.frame.size.width+15, 3,  self.fbLike.frame.size.width,  self.fbLike.frame.size.height);
        [self.fbLoginButton addTarget:self action:@selector(fbLogin:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.fbLoginButton];
    }
   
}

- (void)showFBLikeButton{
    
    if (!self.fbLike) {
        
        self.fbLike = [[FBLikeControl alloc] init];
        self.fbLike.objectType = FBLikeControlObjectTypePage;
        self.fbLike.objectID = @"136288153081650";
        self.fbLike.frame = CGRectMake(25, 3, self.fbLike.frame.size.width, self.fbLike.frame.size.height);
        //like.objectID = @"https://www.facebook.com/pages/CompuGhana/136288153081650";
        self.fbLike.likeControlStyle = FBLikeControlStyleButton;
        //like.objectID = @"http://shareitexampleapp.parseapp.com/photo1/";
        self.fbLike.foregroundColor = [HelperClass colorFromHexString:APP_THEME];
        [self.view addSubview:self.fbLike];
    }
}*/

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self.tableCollection reloadData];
    
    [self getFBPosts];
    
    //Enable the like button only if logged in
//    [self showFBLikeButton];
//    [self showFBLoginButton];
//    if ([HelperClass validFBSessionExists]){
//    //if (FBSession.activeSession.state == FBSessionStateCreatedTokenLoaded) {
//        NSLog(@"Found a cached session");
//        [self setupFBLoginView];
//    }
//    else{
//        
//        [self setupFBLogoutView];
//    }
    
}



//-(BOOL)validFBSessionExists{
//    if (FBSession.activeSession.isOpen){
//        NSLog(@"Facebook accessToken:%@",FBSession.activeSession.accessTokenData.accessToken);
//        return YES;
//    }
//    else if (FBSession.activeSession.state == FBSessionStateCreatedTokenLoaded)
//    {
//        // Cached token exist, Session needs to be re-opened
//        [FBSession.activeSession openWithBehavior:FBSessionLoginBehaviorUseSystemAccountIfPresent completionHandler:nil];
//        return YES;
//    }
//    return NO;
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UI Update Methods

- (void)getFBPosts {
    
    [[AppDelegate instance] showBusyView:@"Loading Posts..."];
    
    [WebHandler getFacebookPostswithCallback:^(id object, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!error) {
                _fbData =(NSDictionary*)object;
                [_tableCollection reloadData];
            }
            [[AppDelegate instance] hideBusyView];
        });
    }];
}

- (void)updateFBProfileOnUI:(NSDictionary *)fbProfileDict {
    
    NSString *likes = fbProfileDict[@"likes"];
    NSString *talks = fbProfileDict[@"talking_about_count"];
    NSString *bannerImgUrl = fbProfileDict[@"cover"][@"source"];
    
    [HelperClass loadImageWithURL:bannerImgUrl andCompletionBlock:^(UIImage *img, NSData *imgData) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (img) {
                self.fbBannerImage.image = img;
            }
            
            self.talksLabel.text = [NSString stringWithFormat:@"%@ talks about it", talks];
            self.likesLabel.text = [NSString stringWithFormat:@"%@ likes", likes];
        });
    }];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([[segue destinationViewController] isKindOfClass:[AVHFBPostViewController class]]) {
        
        NSIndexPath *path = [self.tableCollection indexPathForSelectedRow];
        NSDictionary *postDict = _fbData[@"data"][path.row];
        
        NSLog(@"Post Dict: %@", postDict);
        
        AVHFBPostViewController *fbPostVC = [segue destinationViewController];
        fbPostVC.fbPostDict = postDict;
    }
}

#pragma mark - Button Actions

- (void)navgationBackClicked:(id)sender {
    
    if (_isFromMenu) {
        [self.sideMenuViewController setContentViewController:[AppDelegate instance].homeVC];
        [self.sideMenuViewController hideMenuViewController];
    }
    else {
        _isViewPopped = YES;
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

- (IBAction)equireListClicked:(id)sender {
    
    UINavigationController *enquireVCNav = [self.storyboard instantiateViewControllerWithIdentifier:@"EnquireViewNavigation"];
    
    [self.sideMenuViewController setContentViewController:enquireVCNav];
    [self.sideMenuViewController hideMenuViewController];
}

#pragma mark - TableView Delegates

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    
    return [_fbData[@"data"] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *fbDataCellId = @"fbCell";
    FBTableViewCell *tableCell = [tableView dequeueReusableCellWithIdentifier:fbDataCellId];
    NSString *_message = _fbData[@"data"][indexPath.row][@"message"];
    tableCell.postText.text = (_message.length>0)?_message:_fbData[@"data"][indexPath.row][@"story"];
    NSArray *_likes = _fbData[@"data"][indexPath.row][@"likes"][@"data"];
    NSArray *_comments = _fbData[@"data"][indexPath.row][@"comments"][@"data"];
    NSString *_imagURL = _fbData[@"data"][indexPath.row][@"picture"];
    tableCell.commentsText.text = [NSString stringWithFormat:@"%lu Comments",(unsigned long)[_comments count]];
    tableCell.likesText.text = [NSString stringWithFormat:@"%lu Likes",(unsigned long)[_likes count]];

     if (indexPath.row % 2 == 0) {
         
         [tableCell setBlueTheme];
     }
     else{
      
         [tableCell setWhiteTheme];
     }
    
    tableCell.iconImage.image = nil;
    [tableCell.activityView startAnimating];
    NSString *identifier = [NSString stringWithFormat:@"Cell%ld" ,(long)indexPath.row];
    if([self.cachedImages objectForKey:identifier] != nil){
        tableCell.iconImage.image = [self.cachedImages valueForKey:identifier];
        [tableCell.activityView stopAnimating];

    }else{
        
        char const * s = [identifier  UTF8String];
        
        dispatch_queue_t queue = dispatch_queue_create(s, 0);
        
        dispatch_async(queue, ^{
            
            UIImage *img = nil;
            
            NSData *data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:_imagURL]];
            
            img = [[UIImage alloc] initWithData:data];

            dispatch_async(dispatch_get_main_queue(), ^{
                
                if ([tableView indexPathForCell:tableCell].row == indexPath.row) {
                    
                    [self.cachedImages setValue:img forKey:identifier];
                    
                    tableCell.iconImage.image = [self.cachedImages valueForKey:identifier];
                    [tableCell.activityView stopAnimating];

                }
            });//end
        });//end
    }
    
    tableCell.selectionStyle = UITableViewCellSelectionStyleNone;
                             
    return tableCell;
}

#pragma mark - FBLogin

/*- (void)fbLogin:(id)sender{
    
    if (FBSession.activeSession.state == FBSessionStateOpen
        || FBSession.activeSession.state == FBSessionStateOpenTokenExtended) {
        
        // Close the session and remove the access token from the cache
        // The session state handler (in the app delegate) will be called automatically
        [FBSession.activeSession closeAndClearTokenInformation];
        [FBSession.activeSession close];
        [FBSession setActiveSession:nil];
        
        // If the session state is not any of the two "open" states when the button is clicked
    } else {
        // Open a session showing the user the login UI
        // You must ALWAYS ask for public_profile permissions when opening a session
        [FBSession openActiveSessionWithReadPermissions:@[@"public_profile"]
                                           allowLoginUI:YES
                                      completionHandler:
         ^(FBSession *session, FBSessionState state, NSError *error) {
             
             [self sessionStateChanged:session state:state error:error];
         }];
    }
    
}


// This method will handle ALL the session state changes in the app
- (void)sessionStateChanged:(FBSession *)session state:(FBSessionState) state error:(NSError *)error
{
    // If the session was opened successfully
    if (!error && state == FBSessionStateOpen){
        NSLog(@"Session opened");
        // Show the user the logged-in UI
        [self setupFBLoginView];
        return;
    }
    if (state == FBSessionStateClosed || state == FBSessionStateClosedLoginFailed){
        // If the session is closed
        NSLog(@"Session closed");
        // Show the user the logged-out UI
        [self setupFBLogoutView];
    }
    
    // Handle errors
    if (error){
        NSLog(@"Error");
        NSString *alertText;
        NSString *alertTitle;
        // If the error requires people using an app to make an action outside of the app in order to recover
        if ([FBErrorUtility shouldNotifyUserForError:error] == YES){
            alertTitle = @"Something went wrong";
            alertText = [FBErrorUtility userMessageForError:error];
            [self showMessage:alertText withTitle:alertTitle];
        } else {
            
            // If the user cancelled login, do nothing
            if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryUserCancelled) {
                NSLog(@"User cancelled login");
                
                // Handle session closures that happen outside of the app
            } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryAuthenticationReopenSession){
                alertTitle = @"Session Error";
                alertText = @"Your current session is no longer valid. Please log in again.";
                [self showMessage:alertText withTitle:alertTitle];
                
                // For simplicity, here we just show a generic message for all other errors
                // You can learn how to handle other errors using our guide: https://developers.facebook.com/docs/ios/errors
            } else {
                //Get more error information from the error
                NSDictionary *errorInformation = [[[error.userInfo objectForKey:@"com.facebook.sdk:ParsedJSONResponseKey"] objectForKey:@"body"] objectForKey:@"error"];
                
                // Show the user an error message
                alertTitle = @"Something went wrong";
                alertText = [NSString stringWithFormat:@"Please retry. \n\n If the problem persists contact us and mention this error code: %@", [errorInformation objectForKey:@"message"]];
                [self showMessage:alertText withTitle:alertTitle];
            }
        }
        // Clear this token
        [FBSession.activeSession closeAndClearTokenInformation];
        // Show the user the logged-out UI
        [self setupFBLogoutView];
    }
}

- (void)setupFBLoginView{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self.fbLike setEnabled:YES];
        [self.fbLike setAlpha:1.0f];
        [self.fbLoginButton setImage:[UIImage imageNamed:@"fblogout"] forState:UIControlStateNormal];
        
    });

}

- (void)setupFBLogoutView{
    
    dispatch_async(dispatch_get_main_queue(), ^{

        [self.fbLike setEnabled:NO];
        [self.fbLike setAlpha:0.5f];
        [self.fbLoginButton setImage:[UIImage imageNamed:@"fblogin"] forState:UIControlStateNormal];

    });

}


- (void)showMessage:(NSString *)text withTitle:(NSString *)title
{
    [[[UIAlertView alloc] initWithTitle:title
                                message:text
                               delegate:self
                      cancelButtonTitle:@"OK!"
                      otherButtonTitles:nil] show];
}*/

@end
