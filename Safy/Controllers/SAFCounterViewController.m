//
//  SAFCounterViewController.m
//  Safy
//
//  Created by Renzo Crisostomo on 18/06/14.
//  Copyright (c) 2014 Renzo Crisóstomo. All rights reserved.
//

#import "SAFCounterViewController.h"
#import "SAFSafy.h"
#import "SAFTime.h"
#import "SAFPickTableViewController.h"
#import "SAFChartViewController.h"

@interface SAFCounterViewController () <SAFPickTableViewControllerDelegate>

@property (nonatomic, strong) MSWeakTimer *timer;
@property (nonatomic, strong) SAFSafy *safy;
@property (nonatomic, weak) IBOutlet TOMSMorphingLabel *tickLabel;
@property (nonatomic, weak) IBOutlet TOMSMorphingLabel *safyLabel;
@property (nonatomic, strong) UIPopoverController *settingsController;

- (void)findSelectedSafyAndStartTimer;
- (void)setupNavigationItemButtons;
- (void)tick:(id)sender;
- (IBAction)oops:(id)sender;
- (void)charts:(id)sender;
- (void)pick:(id)sender;

@end

@implementation SAFCounterViewController

#pragma mark - View controller life cycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Safy";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self findSelectedSafyAndStartTimer];
    [self setupNavigationItemButtons];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Private methods

- (void)setupNavigationItemButtons
{
    UIBarButtonItem *btnPick = [[UIBarButtonItem alloc]
                                initWithImage:[UIImage imageNamed:@"Pick"]
                                style:UIBarButtonItemStyleBordered
                                target:self
                                action:@selector(pick:)];
    UIBarButtonItem *btnCharts = [[UIBarButtonItem alloc]
                                  initWithImage:[UIImage imageNamed:@"Chart"]
                                  style:UIBarButtonItemStyleBordered
                                  target:self
                                  action:@selector(charts:)];
    self.navigationItem.rightBarButtonItems = @[btnCharts, btnPick];
}

- (void)findSelectedSafyAndStartTimer
{
    @weakify(self);
    
    NSManagedObjectContext *privateContext = [NSManagedObjectContext MR_context];
    [privateContext performBlock:^{
        
        @strongify(self);
        
        NSArray *privateObjects = [SAFSafy MR_findAllWithPredicate:[NSPredicate predicateWithFormat:@"selected == %@",
                                                                    [NSNumber numberWithBool:YES]]
                                                         inContext:privateContext];
        NSArray *privateObjectIDs = [privateObjects valueForKey:@"objectID"];
        dispatch_async(dispatch_get_main_queue(), ^{
            NSPredicate *mainPredicate = [NSPredicate predicateWithFormat:@"self IN %@", privateObjectIDs];
            NSArray *results = [SAFSafy MR_findAllWithPredicate:mainPredicate];
            self.safy = [results firstObject];
            [self startTimer];
        });
    }];
}

- (void)startTimer
{
    self.timer = [MSWeakTimer
                  scheduledTimerWithTimeInterval:1.0f
                  target:self
                  selector:@selector(tick:)
                  userInfo:nil
                  repeats:YES
                  dispatchQueue:dispatch_get_main_queue()];
}

- (void)tick:(id)sender
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *aDateComponents = [calendar components:(NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit)
                                                    fromDate:self.safy.currentStartDate
                                                      toDate:[NSDate date]
                                                     options:0];
    NSString *print = [NSString stringWithFormat:@"%ld:%02ld:%02ld", (long)[aDateComponents hour],
                       (long)[aDateComponents minute],
                       (long)[aDateComponents second]];
    [self.tickLabel setText:print];
    [self.safyLabel setText:[NSString stringWithFormat:@"%@ without any\n%@",
                             [self.safy.currentStartDate.timeAgoSinceNow stringByReplacingOccurrencesOfString:@" ago"
                                                                                                   withString:@""],
                             [self.safy.text lowercaseString]]];
}

- (void)charts:(id)sender
{
    SAFChartViewController *viewController = [[SAFChartViewController alloc] initWithNibName:nil
                                                                                      bundle:nil];
    viewController.safy = self.safy;
    [self.navigationController pushViewController:viewController
                                         animated:YES];
}

- (IBAction)oops:(id)sender
{
    @weakify(self);
    
    [self.timer invalidate];
    NSDate *currentStartDate = self.safy.currentStartDate;
    NSDate *endDate = [NSDate date];
    self.safy.currentStartDate = endDate;
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
        
        @strongify(self);
        
        SAFSafy *safy = (SAFSafy *)[localContext objectWithID:[self.safy objectID]];
        SAFTime *time = [SAFTime MR_createInContext:localContext];
        time.startDate = currentStartDate;
        time.endDate = endDate;
        safy.currentStartDate = time.endDate;
        [[safy timesSet] addObject:time];
    }];
    [self startTimer];
}

- (void)pick:(id)sender
{
    SAFPickTableViewController *viewController = [[SAFPickTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
    viewController.selectedSafy = self.safy;
    viewController.delegate = self;
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
    UIPopoverController *popoverController = [[UIPopoverController alloc] initWithContentViewController:navigationController];
    [popoverController presentPopoverFromBarButtonItem:sender
                              permittedArrowDirections:UIPopoverArrowDirectionUp
                                              animated:YES];
    self.settingsController = popoverController;
}

#pragma mark - SAFPickTableViewControllerDelegate

- (void)safyPicked:(SAFSafy *)safy
{
    self.safy = safy;
}

@end
