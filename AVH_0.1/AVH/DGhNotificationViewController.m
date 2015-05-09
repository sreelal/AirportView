//
//  DGhNotificationViewController.m
//  DeviceGH
//
//  Created by Sreelash S on 27/01/15.
//  Copyright (c) 2015 Sreelal H. All rights reserved.
//

#import "DGhNotificationViewController.h"
#import "HelperClass.h"
#import "NotificationCell.h"
#import "AppDelegate.h"
#import "WebHandler.h"
#import "Notification.h"

@interface DGhNotificationViewController ()

@property (nonatomic, strong) NSMutableArray *notifications;

@end

@implementation DGhNotificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
   [self.navigationItem.rightBarButtonItem setTitleTextAttributes:[HelperClass getRightBarButtonItemTextAttributes] forState:UIControlStateNormal];
    
    [self loadNotifications];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Webservice

- (void)loadNotifications {
    
    [[AppDelegate instance] showBusyView:@"Loading..."];
    
    [WebHandler getNotificationsWithCallback:^(id object, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.notifications = (NSMutableArray *)object;
            
            if (self.notifications.count) {
                [self.tableView reloadData];
            }
            
            [[AppDelegate instance] hideBusyView];
        });
    }];
}

#pragma mark - Button Actions

- (IBAction)equireListClicked:(id)sender {
    
    UINavigationController *enquireVCNav = [self.storyboard instantiateViewControllerWithIdentifier:@"EnquireViewNavigation"];
    //DGHEnquireViewController *enquireView = [[enquireVCNav viewControllers] firstObject];
    
    [self.sideMenuViewController setContentViewController:enquireVCNav];
    [self.sideMenuViewController hideMenuViewController];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.notifications.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NotificationCell *notifCell = (NotificationCell *)[tableView dequeueReusableCellWithIdentifier:CELL_ID_NOTIFICATION forIndexPath:indexPath];
    
    Notification *notification = self.notifications[indexPath.row];
    
    notifCell.notifTimeLabel.text = [HelperClass getStringDateFromTimeStamp:notification.timeSend];
    notifCell.notifDescLabel.text = notification.message;
    
    return notifCell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
