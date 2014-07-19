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

@interface SAFCounterViewController ()

@property (nonatomic, strong) MSWeakTimer *timer;
@property (nonatomic, strong) SAFSafy *safy;
@property (nonatomic, weak) TOMSMorphingLabel *tickLabel;
@property (nonatomic, weak) TOMSMorphingLabel *safyLabel;
@property (nonatomic, strong) UIPopoverController *settingsController;

- (void)findSelectedSafyAndStartTime;
- (void)setupLabels;
- (void)setupNavigationItemButtons;
- (void)tick:(id)sender;
- (void)oops:(id)sender;
- (void)charts:(id)sender;
- (void)settings:(id)sender;

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
    [self setupLabels];
    [self findSelectedSafyAndStartTime];
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
                                action:@selector(settings:)];
    UIBarButtonItem *btnCharts = [[UIBarButtonItem alloc]
                                  initWithImage:[UIImage imageNamed:@"Chart"]
                                  style:UIBarButtonItemStyleBordered
                                  target:self
                                  action:@selector(charts:)];
    self.navigationItem.rightBarButtonItems = @[btnCharts, btnPick];
}

- (void)setupLabels
{
    TOMSMorphingLabel *tickLabel = [[TOMSMorphingLabel alloc] initWithFrame:CGRectMake(0,
                                                                                       (self.view.frame.size.height - 44 - 20) / 3,
                                                                                       self.view.frame.size.width,
                                                                                       (self.view.frame.size.height - 44 - 20) / 3)];
    tickLabel.backgroundColor = [UIColor clearColor];
    tickLabel.textAlignment = NSTextAlignmentCenter;
    tickLabel.font = [UIFont systemFontOfSize:120.0f];
    tickLabel.textColor = [UIColor colorWithHexString:@"#FF9500"];
    [tickLabel setText:@"0:00:00"];
    [self.view addSubview:tickLabel];
    self.tickLabel = tickLabel;
    TOMSMorphingLabel *safyLabel = [[TOMSMorphingLabel alloc] initWithFrame:CGRectMake(132,
                                                                                       0,
                                                                                       self.view.frame.size.width - (132 * 2),
                                                                                       (self.view.frame.size.height - 44 - 20) / 3)];
    safyLabel.backgroundColor = [UIColor clearColor];
    safyLabel.textAlignment = NSTextAlignmentCenter;
    safyLabel.font = [UIFont systemFontOfSize:60.0f];
    safyLabel.textColor = [UIColor colorWithHexString:@"#FF5E3A"];
    safyLabel.numberOfLines = 0;
    [safyLabel setText:@"... without a ... issue"];
    [self.view addSubview:safyLabel];
    self.safyLabel = safyLabel;
    UIButton *oopsButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    oopsButton.frame = CGRectMake(0,
                                  ((self.view.frame.size.height - 44 - 20) / 3) * 2,
                                  self.view.frame.size.width,
                                  (self.view.frame.size.height - 44 - 20) / 3);
    [oopsButton.titleLabel setFont:[UIFont systemFontOfSize:80.0f]];
    [oopsButton setTitle:@"oops!"
                forState:UIControlStateNormal];
    [oopsButton setTintColor:[UIColor colorWithHexString:@"#FF5E3A"]];
    [self.view addSubview:oopsButton];
    [oopsButton addTarget:self
                   action:@selector(oops:)
         forControlEvents:UIControlEventTouchUpInside];
}

- (void)findSelectedSafyAndStartTime
{
    NSManagedObjectContext *privateContext = [NSManagedObjectContext MR_context];
    [privateContext performBlock:^{
        NSArray *privateObjects = [SAFSafy MR_findAllWithPredicate:[NSPredicate predicateWithFormat:@"selected == %@",
                                                                    [NSNumber numberWithBool:YES]]
                                                         inContext:privateContext];
        NSArray *privateObjectIDs = [privateObjects valueForKey:@"objectID"];
        dispatch_async(dispatch_get_main_queue(), ^{
            NSPredicate *mainPredicate = [NSPredicate predicateWithFormat:@"self IN %@", privateObjectIDs];
            NSArray *results = [SAFSafy MR_findAllWithPredicate:mainPredicate];
            self.safy = [results firstObject];
            self.timer = [MSWeakTimer
                          scheduledTimerWithTimeInterval:1.0f
                          target:self
                          selector:@selector(tick:)
                          userInfo:nil
                          repeats:YES
                          dispatchQueue:dispatch_get_main_queue()];
        });
    }];
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
    [self.safyLabel setText:[NSString stringWithFormat:@"%@ without a %@",
                             [self.safy.currentStartDate.timeAgoSinceNow stringByReplacingOccurrencesOfString:@" ago"
                                                                                                   withString:@""],
                             self.safy.text]];
}

- (void)charts:(id)sender
{
    
}

- (void)oops:(id)sender
{
    @weakify(self);
    
    [self.timer invalidate];
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
        
        @strongify(self);
        
        SAFSafy *safy = (SAFSafy *)[localContext objectWithID:[self.safy objectID]];
        SAFTime *time = [SAFTime MR_createInContext:localContext];
        time.startDate = self.safy.currentStartDate;
        time.endDate = [NSDate date];
        safy.currentStartDate = time.endDate;
        [time setSafy:safy];
        [safy addTimesObject:time];
    } completion:^(BOOL success, NSError *error) {
        [self findSelectedSafyAndStartTime];
    }];
}

- (void)settings:(id)sender
{
    SAFPickTableViewController *viewController = [[SAFPickTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
    UIPopoverController *popoverController = [[UIPopoverController alloc] initWithContentViewController:navigationController];
    [popoverController presentPopoverFromBarButtonItem:sender
                              permittedArrowDirections:UIPopoverArrowDirectionUp
                                              animated:YES];
    self.settingsController = popoverController;
}

@end
