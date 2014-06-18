//
//  SAFTime.h
//  Safy
//
//  Created by Renzo Crisostomo on 18/06/14.
//  Copyright (c) 2014 Renzo Crisóstomo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class SAFSafy;

@interface SAFTime : NSManagedObject

@property (nonatomic, retain) NSDate * startDate;
@property (nonatomic, retain) NSDate * endDate;
@property (nonatomic, retain) SAFSafy *safy;

@end
