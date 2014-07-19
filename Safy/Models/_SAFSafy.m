// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to SAFSafy.m instead.

#import "_SAFSafy.h"

const struct SAFSafyAttributes SAFSafyAttributes = {
	.currentStartDate = @"currentStartDate",
	.selected = @"selected",
	.text = @"text",
};

const struct SAFSafyRelationships SAFSafyRelationships = {
	.times = @"times",
};

const struct SAFSafyFetchedProperties SAFSafyFetchedProperties = {
};

@implementation SAFSafyID
@end

@implementation _SAFSafy

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"SAFSafy" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"SAFSafy";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"SAFSafy" inManagedObjectContext:moc_];
}

- (SAFSafyID*)objectID {
	return (SAFSafyID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"selectedValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"selected"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}




@dynamic currentStartDate;






@dynamic selected;



- (BOOL)selectedValue {
	NSNumber *result = [self selected];
	return [result boolValue];
}

- (void)setSelectedValue:(BOOL)value_ {
	[self setSelected:[NSNumber numberWithBool:value_]];
}

- (BOOL)primitiveSelectedValue {
	NSNumber *result = [self primitiveSelected];
	return [result boolValue];
}

- (void)setPrimitiveSelectedValue:(BOOL)value_ {
	[self setPrimitiveSelected:[NSNumber numberWithBool:value_]];
}





@dynamic text;






@dynamic times;

	
- (NSMutableOrderedSet*)timesSet {
	[self willAccessValueForKey:@"times"];
  
	NSMutableOrderedSet *result = (NSMutableOrderedSet*)[self mutableOrderedSetValueForKey:@"times"];
  
	[self didAccessValueForKey:@"times"];
	return result;
}
	






@end
