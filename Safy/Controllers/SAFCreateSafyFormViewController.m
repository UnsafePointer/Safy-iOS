//
//  SAFCreateSafyFormViewController.m
//  Safy
//
//  Created by Renzo Crisostomo on 19/07/14.
//  Copyright (c) 2014 Renzo Crisóstomo. All rights reserved.
//

#import "SAFCreateSafyFormViewController.h"
#import "SAFCreateSafyForm.h"
#import "SAFSafy.h"
#import "SAFPickTableViewController.h"

@interface SAFCreateSafyFormViewController ()

- (void)new;

@end

@implementation SAFCreateSafyFormViewController

- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil
                               bundle:nibBundleOrNil]) {
        self.formController.form = [[SAFCreateSafyForm alloc] init];
        self.title = @"New";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)new
{
    SAFCreateSafyForm *form = self.formController.form;
    if ([form.name stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:@"Name can't be empty."
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        [alertView show];
        return;
    }
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
        SAFSafy *safy = [SAFSafy MR_createInContext:localContext];
        safy.text = [[form.name pluralizeString] capitalizedString];
        safy.selected = [NSNumber numberWithBool:NO];
        safy.currentStartDate = [NSDate date];
    }];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
