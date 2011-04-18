/*
 *  Copyright 2010 TheBox
 *  All rights reserved.
 *
 *  This file is part of TheBox
 *
 *  Created by Markos Charatzas <[firstname.lastname@gmail.com]> on 16/04/2011.
 *  Contributor(s): .-
 */
#import "TheBoxPredicates.h"
#import "TheBoxBinarySearch.h"

@interface Foo : NSObject <TheBoxPredicate>
{
	@private
		NSNumber* categoryId;
}
@property(nonatomic, assign) NSNumber* categoryId;

-(id)init:(NSNumber*) categoryId;
@end

@implementation Foo

@synthesize categoryId;

-(id)init:(NSNumber*) aCategoryId
{
	self = [super init];
	
	if (self) {
		self.categoryId = aCategoryId;
	}
	
return self;
}

-(BOOL)applies:(id)object
{
	NSNumber *theCategoryId = [object objectForKey:@"id"];
	
return [categoryId isEqual:theCategoryId];
}

-(BOOL)isHigherThan:(id)object
{
	NSNumber *theCategoryId = [object objectForKey:@"id"];
	
return [categoryId intValue] > [theCategoryId intValue];
}

@end


@implementation TheBoxPredicates

+(id<TheBoxPredicate>)newCategoryIdPredicate:(NSNumber *)categoryId {
return [[Foo alloc] init:categoryId];
}

@end
