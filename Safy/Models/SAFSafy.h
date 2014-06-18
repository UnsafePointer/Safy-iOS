//
//  SAFSafy.h
//  Safy
//
//  Created by Renzo Crisostomo on 18/06/14.
//  Copyright (c) 2014 Renzo Crisóstomo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class SAFTime;

@interface SAFSafy : NSManagedObject

@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) NSNumber * selected;
@property (nonatomic, retain) NSDate * currentStartDate;
@property (nonatomic, retain) NSSet *times;
@end

@interface SAFSafy (CoreDataGeneratedAccessors)

- (void)addTimesObject:(SAFTime *)value;
- (void)removeTimesObject:(SAFTime *)value;
- (void)addTimes:(NSSet *)values;
- (void)removeTimes:(NSSet *)values;

@end
