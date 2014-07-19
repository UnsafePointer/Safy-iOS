// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to SAFSafy.h instead.

#import <CoreData/CoreData.h>


extern const struct SAFSafyAttributes {
	__unsafe_unretained NSString *currentStartDate;
	__unsafe_unretained NSString *selected;
	__unsafe_unretained NSString *text;
} SAFSafyAttributes;

extern const struct SAFSafyRelationships {
	__unsafe_unretained NSString *times;
} SAFSafyRelationships;

extern const struct SAFSafyFetchedProperties {
} SAFSafyFetchedProperties;

@class SAFTime;





@interface SAFSafyID : NSManagedObjectID {}
@end

@interface _SAFSafy : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (SAFSafyID*)objectID;





@property (nonatomic, strong) NSDate* currentStartDate;



//- (BOOL)validateCurrentStartDate:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* selected;



@property BOOL selectedValue;
- (BOOL)selectedValue;
- (void)setSelectedValue:(BOOL)value_;

//- (BOOL)validateSelected:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* text;



//- (BOOL)validateText:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSOrderedSet *times;

- (NSMutableOrderedSet*)timesSet;





@end

@interface _SAFSafy (CoreDataGeneratedAccessors)

- (void)addTimes:(NSOrderedSet*)value_;
- (void)removeTimes:(NSOrderedSet*)value_;
- (void)addTimesObject:(SAFTime*)value_;
- (void)removeTimesObject:(SAFTime*)value_;

@end

@interface _SAFSafy (CoreDataGeneratedPrimitiveAccessors)


- (NSDate*)primitiveCurrentStartDate;
- (void)setPrimitiveCurrentStartDate:(NSDate*)value;




- (NSNumber*)primitiveSelected;
- (void)setPrimitiveSelected:(NSNumber*)value;

- (BOOL)primitiveSelectedValue;
- (void)setPrimitiveSelectedValue:(BOOL)value_;




- (NSString*)primitiveText;
- (void)setPrimitiveText:(NSString*)value;





- (NSMutableOrderedSet*)primitiveTimes;
- (void)setPrimitiveTimes:(NSMutableOrderedSet*)value;


@end
