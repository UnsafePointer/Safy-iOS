//
//  SAFCreateSafyFormViewController.m
//  Safy
//
//  Created by Renzo Crisostomo on 19/07/14.
//  Copyright (c) 2014 Renzo Crisóstomo. All rights reserved.
//

#import "SAFCreateSafyFormViewController.h"
#import "SAFCreateSafyForm.h"

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
        
    }
}

@end
