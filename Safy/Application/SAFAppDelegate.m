//
//  SAFAppDelegate.m
//  Safy
//
//  Created by Renzo Crisostomo on 18/06/14.
//  Copyright (c) 2014 Renzo Crisóstomo. All rights reserved.
//

#import "SAFAppDelegate.h"
#import "SAFCounterViewController.h"
#import "SAFSafy.h"
#import "SAFTime.h"

@interface SAFAppDelegate ()

- (void)seedDataIfNeeded;

@end

@implementation SAFAppDelegate

#pragma mark - Application life cycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.tintColor = [UIColor colorWithHexString:@"#FF9500"];
    [self.window makeKeyAndVisible];
    [MagicalRecord setupAutoMigratingCoreDataStack];
    [self seedDataIfNeeded];
    SAFCounterViewController *viewController = [[SAFCounterViewController alloc]
                                                initWithNibName:nil
                                                bundle:nil];
    self.rootController = [[UINavigationController alloc]
                           initWithRootViewController:viewController];
    self.rootController.navigationBar.translucent = NO;
    self.window.rootViewController = self.rootController;
    return YES;
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [MagicalRecord cleanUp];
}

#pragma mark - Private methods

- (void)seedDataIfNeeded
{
    if (![SAFSafy MR_findFirst]) {
        [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
            SAFSafy *safy = [SAFSafy MR_createInContext:localContext];
            safy.text = @"Accidents";
            safy.selected = [NSNumber numberWithBool:YES];
            safy.currentStartDate = [NSDate date];
        }];
    }
}

@end
