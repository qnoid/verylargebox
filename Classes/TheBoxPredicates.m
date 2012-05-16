/*
 *  Copyright 2010 TheBox
 *  All rights reserved.
 *
 *  This file is part of TheBox
 *
 *  Created by Markos Charatzas (@qnoid) on 16/04/2011.
 *  Contributor(s): .-
 */
#import "TheBoxPredicates.h"

@implementation TheBoxPredicateOnLocation

-(BOOL)does:(id)thiz match:(id)that
{
	NSNumber *thizCategoryId = [[thiz objectForKey:@"location"] objectForKey:@"id"];
	NSNumber *thatCategoryId = [that objectForKey:@"location_id"];
	
return [thizCategoryId isEqual:thatCategoryId];
}

-(BOOL)is:(id)thiz higherThan:(id)that
{
	NSNumber *thizCategoryId = [thiz objectForKey:@"location_id"];
	NSNumber *thatCategoryId = [[that objectForKey:@"location"] objectForKey:@"id"];
	
return [thizCategoryId intValue] > [thatCategoryId intValue];
}

@end


@implementation TheBoxPredicates

+(TheBoxPredicateOnLocation*)newLocationIdPredicate {
return [[TheBoxPredicateOnLocation alloc] init];
}

@end
