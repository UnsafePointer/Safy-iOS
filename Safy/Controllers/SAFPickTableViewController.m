//
//  SAFSettingsTableViewController.m
//  Safy
//
//  Created by Renzo Crisostomo on 19/07/14.
//  Copyright (c) 2014 Renzo Crisóstomo. All rights reserved.
//

#import "SAFPickTableViewController.h"
#import "SAFSafy.h"
#import "SAFCreateSafyFormViewController.h"

@interface SAFPickTableViewController () <NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

- (void)setupFetchedResultsController;
- (void)setupNavigationButtons;

@end

@implementation SAFPickTableViewController

static NSString * const kCellReuseIdentifier = @"kCellReuseIdentifier";

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        self.title = @"Pick";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tableView registerClass:[UITableViewCell class]
           forCellReuseIdentifier:kCellReuseIdentifier];
    [self setupFetchedResultsController];
    [self setupNavigationButtons];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Private Methods

- (void)setupFetchedResultsController
{
    self.fetchedResultsController = [SAFSafy MR_fetchAllSortedBy:@"text"
                                                       ascending:YES
                                                   withPredicate:nil
                                                         groupBy:nil
                                                        delegate:self];
    [self.fetchedResultsController performFetch:NULL];
}

- (void)setupNavigationButtons
{
    UIBarButtonItem *btnPlus = [[UIBarButtonItem alloc]
                                initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                target:self
                                action:@selector(add:)];
    self.navigationItem.rightBarButtonItem = btnPlus;
}

- (void)add:(id)sender
{
    SAFCreateSafyFormViewController *viewController = [[SAFCreateSafyFormViewController alloc] initWithNibName:nil
                                                                                                        bundle:nil];
    [self.navigationController pushViewController:viewController
                                         animated:YES];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.fetchedResultsController.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    id<NSFetchedResultsSectionInfo> section = self.fetchedResultsController.sections[sectionIndex];
    return section.numberOfObjects;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellReuseIdentifier
                                                            forIndexPath:indexPath];
    SAFSafy *safy = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = safy.text;
    if ([safy.selected boolValue]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}

- (BOOL)tableView:(UITableView*)tableView canEditRowAtIndexPath:(NSIndexPath*)indexPath
{
    SAFSafy *safy = [self.fetchedResultsController objectAtIndexPath:indexPath];
    if ([safy.selected boolValue] == YES) {
        return NO;
    }
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        SAFSafy *safy = [self.fetchedResultsController objectAtIndexPath:indexPath];
        NSManagedObjectID *objectID = safy.objectID;
        [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
            SAFSafy *safy = (SAFSafy *)[localContext objectWithID:objectID];
            [safy MR_deleteEntity];
        }];
    }
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath
                             animated:YES];
    SAFSafy *safy = [self.fetchedResultsController objectAtIndexPath:indexPath];
    NSManagedObjectID *newSelectedSafyObjectID = safy.objectID;
    NSManagedObjectID *oldSelectedSafyObjectID = self.selectedSafy.objectID;
    if ([safy.selected boolValue] != YES) {
        [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
            SAFSafy *newSelectedSafy = (SAFSafy *)[localContext objectWithID:newSelectedSafyObjectID];
            newSelectedSafy.selected = [NSNumber numberWithBool:YES];
            SAFSafy *oldSelectedSafy = (SAFSafy *)[localContext objectWithID:oldSelectedSafyObjectID];
            oldSelectedSafy.selected = [NSNumber numberWithBool:NO];
        }];
    }
}

#pragma mark - NSFetchedResultsControllerDelegate

- (void)controllerWillChangeContent:(NSFetchedResultsController*)controller
{
    [self.tableView beginUpdates];
}

- (void)controllerDidChangeContent:(NSFetchedResultsController*)controller
{
    [self.tableView endUpdates];
}

- (void)controller:(NSFetchedResultsController*)controller
   didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath*)indexPath
     forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath*)newIndexPath
{
    if (type == NSFetchedResultsChangeInsert) {
        [self.tableView insertRowsAtIndexPaths:@[newIndexPath]
                              withRowAnimation:UITableViewRowAnimationAutomatic];
    } else if (type == NSFetchedResultsChangeMove) {
        [self.tableView moveRowAtIndexPath:indexPath
                               toIndexPath:newIndexPath];
    } else if (type == NSFetchedResultsChangeDelete) {
        [self.tableView deleteRowsAtIndexPaths:@[indexPath]
                              withRowAnimation:UITableViewRowAnimationAutomatic];
    } else if (type == NSFetchedResultsChangeUpdate) {
        SAFSafy *safy = [self.fetchedResultsController objectAtIndexPath:indexPath];
        if ([safy.selected boolValue] == YES) {
            self.selectedSafy = safy;
            [self.delegate safyPicked:safy];
        }
        [self.tableView reloadRowsAtIndexPaths:@[indexPath]
                              withRowAnimation:UITableViewRowAnimationFade];
    }
}

@end
