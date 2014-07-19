// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to SAFTime.h instead.

#import <CoreData/CoreData.h>


extern const struct SAFTimeAttributes {
	__unsafe_unretained NSString *endDate;
	__unsafe_unretained NSString *startDate;
} SAFTimeAttributes;

extern const struct SAFTimeRelationships {
	__unsafe_unretained NSString *safy;
} SAFTimeRelationships;

extern const struct SAFTimeFetchedProperties {
} SAFTimeFetchedProperties;

@class SAFSafy;




@interface SAFTimeID : NSManagedObjectID {}
@end

@interface _SAFTime : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (SAFTimeID*)objectID;





@property (nonatomic, strong) NSDate* endDate;



//- (BOOL)validateEndDate:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSDate* startDate;



//- (BOOL)validateStartDate:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) SAFSafy *safy;

//- (BOOL)validateSafy:(id*)value_ error:(NSError**)error_;





@end

@interface _SAFTime (CoreDataGeneratedAccessors)

@end

@interface _SAFTime (CoreDataGeneratedPrimitiveAccessors)


- (NSDate*)primitiveEndDate;
- (void)setPrimitiveEndDate:(NSDate*)value;




- (NSDate*)primitiveStartDate;
- (void)setPrimitiveStartDate:(NSDate*)value;





- (SAFSafy*)primitiveSafy;
- (void)setPrimitiveSafy:(SAFSafy*)value;


@end
