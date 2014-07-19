// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to SAFTime.m instead.

#import "_SAFTime.h"

const struct SAFTimeAttributes SAFTimeAttributes = {
	.endDate = @"endDate",
	.startDate = @"startDate",
};

const struct SAFTimeRelationships SAFTimeRelationships = {
	.safy = @"safy",
};

const struct SAFTimeFetchedProperties SAFTimeFetchedProperties = {
};

@implementation SAFTimeID
@end

@implementation _SAFTime

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"SAFTime" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"SAFTime";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"SAFTime" inManagedObjectContext:moc_];
}

- (SAFTimeID*)objectID {
	return (SAFTimeID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	

	return keyPaths;
}




@dynamic endDate;






@dynamic startDate;






@dynamic safy;

	






@end
