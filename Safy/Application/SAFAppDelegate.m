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
- (void)seedTestDataIfNeeded;

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
    [self seedTestDataIfNeeded];
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

- (void)seedTestDataIfNeeded
{
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
        SAFSafy *safy = [SAFSafy MR_createInContext:localContext];
        safy.text = @"Accidents";
        safy.selected = [NSNumber numberWithBool:YES];
        safy.currentStartDate = [NSDate date];
        NSDate *pivotDate = safy.currentStartDate;
        for (int i = 0; i < 50; i++) {
            SAFTime *time = [SAFTime MR_createInContext:localContext];
            time.endDate = pivotDate;
            pivotDate = [pivotDate dateBySubtractingDays:arc4random() % 20 + 1];
            time.startDate = pivotDate;
            [[safy timesSet] insertObject:time
                                  atIndex:0];
        }
    }];
}

@end
