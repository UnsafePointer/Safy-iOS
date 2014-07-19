//
//  SAFInfoTableViewController.m
//  Safy
//
//  Created by Renzo Crisóstomo on 02/06/14.
//  Copyright (c) 2014 Renzo Crisóstomo. All rights reserved.
//

#import "SAFInfoTableViewController.h"
#import "iLink.h"
#import "SAFDeveloperTableViewController.h"

@interface SAFInfoTableViewController ()

- (NSString *)titleForIndexPath:(NSIndexPath *)indexPath;
- (void)shareOnFacebook;
- (void)shareOnTwitter;
- (void)rateOnAppStore;

@end

@implementation SAFInfoTableViewController

static NSString *cellIdentifier = @"SAFInfoTableViewCell";

#pragma mark - View controller life cycle

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        self.title = @"Info";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tableView registerNib:[UINib nibWithNibName:cellIdentifier
                                               bundle:nil]
         forCellReuseIdentifier:cellIdentifier];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow]
                                  animated:YES];
}

#pragma mark - Private Methods

- (void)shareOnFacebook
{
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
        SLComposeViewController *facebookStatus = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        [facebookStatus setInitialText:@"Check Safy on the AppStore!"];
        [facebookStatus addURL:[[iLink sharedInstance] iLinkGetAppURLforSharing]];
        [self presentViewController:facebookStatus
                           animated:YES
                         completion:nil];
    } else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:@"It seems that you don't have a Facebook account configured."
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        [alertView show];
    }
}

- (void)shareOnTwitter
{
    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
    ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    [accountStore
     requestAccessToAccountsWithType:accountType
     options:nil
     completion:^(BOOL granted, NSError *error) {
         if(granted) {
             NSArray *accounts = [accountStore accountsWithAccountType:accountType];
             if ([accounts count] > 0) {
                 SLComposeViewController *tweetSheet = [SLComposeViewController
                                                        composeViewControllerForServiceType:SLServiceTypeTwitter];
                 [tweetSheet setInitialText:@"Check Safy on the AppStore!"];
                 [tweetSheet addURL:[[iLink sharedInstance] iLinkGetAppURLforSharing]];
                 [self presentViewController:tweetSheet
                                    animated:YES
                                  completion:nil];
             }
             else {
                 dispatch_async(dispatch_get_main_queue(), ^{
                     UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                         message:@"It seems that you don't have a Twitter account configured."
                                                                        delegate:nil
                                                               cancelButtonTitle:@"OK"
                                                               otherButtonTitles:nil];
                     [alertView show];
                 });
             }
         }
     }];
}

- (void)rateOnAppStore
{
    [[iLink sharedInstance] iLinkOpenRatingsPageInAppStore];
}

- (NSString *)titleForIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0: {
            switch (indexPath.row) {
                case 0:
                    return @"Share this app on Facebook";
                case 1:
                    return @"Share this app on Twitter";
                case 2:
                    return @"Rate this app on App Store";
            }
            break;
        }
        case 1: {
            switch (indexPath.row) {
                case 0:
                    return @"Developer";
                case 1:
                    return @"Acknowledgments";
            }
            break;
        }
    }
    return @"";
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 3;
        case 1:
            return 2;
    }
    return 0;
}

- (NSString *)tableView:(UITableView *)tableView
titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return @"Social";
        case 1:
            return @"About";
    }
    return @"";
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier
                                                            forIndexPath:indexPath];
    cell.textLabel.text = [self titleForIndexPath:indexPath];
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIViewController *controller = nil;
    switch (indexPath.section) {
        case 0: {
            switch (indexPath.row) {
                case 0: {
                    [self shareOnFacebook];
                    [self.tableView deselectRowAtIndexPath:indexPath
                                                  animated:YES];
                    break;
                }
                case 1: {
                    [self shareOnTwitter];
                    [self.tableView deselectRowAtIndexPath:indexPath
                                                  animated:YES];
                    break;
                }
                case 2: {
                    [self rateOnAppStore];
                    [self.tableView deselectRowAtIndexPath:indexPath
                                                  animated:YES];
                    break;
                }
            }
            break;
        }
        case 1: {
            switch (indexPath.row) {
                case 0: {
                    controller = [[SAFDeveloperTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
                    break;
                }
                case 1: {
                    NSString *path = [[NSBundle mainBundle] pathForResource:@"Pods-Safy-acknowledgements"
                                                                     ofType:@"plist"];
                    controller = [[VTAcknowledgementsViewController alloc] initWithAcknowledgementsPlistPath:path];
                    break;
                }
            }
            break;
        }
    }
    if (controller != nil) {
        [self.navigationController pushViewController:controller
                                             animated:YES];
    }
}

@end
