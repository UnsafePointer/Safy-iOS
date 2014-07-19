//
//  SAFSettingsTableViewController.h
//  Safy
//
//  Created by Renzo Crisostomo on 19/07/14.
//  Copyright (c) 2014 Renzo Crisóstomo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SAFSafy;

@protocol SAFPickTableViewControllerDelegate <NSObject>
@required
- (void)safyPicked:(SAFSafy *)safy;
@end

@interface SAFPickTableViewController : UITableViewController

@property (nonatomic, strong) SAFSafy *selectedSafy;
@property (nonatomic, weak) id<SAFPickTableViewControllerDelegate> delegate;

@end
