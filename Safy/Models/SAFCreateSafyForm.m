//
//  SAFSafyForm.m
//  Safy
//
//  Created by Renzo Crisostomo on 19/07/14.
//  Copyright (c) 2014 Renzo Crisóstomo. All rights reserved.
//

#import "SAFCreateSafyForm.h"

@implementation SAFCreateSafyForm

- (NSArray *)extraFields
{
    return @[
             @{
                 FXFormFieldTitle: @"Create",
                 FXFormFieldHeader: @"",
                 FXFormFieldAction: @"new"
                 }
             ];
}

@end
