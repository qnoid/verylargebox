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

@interface TheBoxPredicateOnCategory : NSObject <TheBoxPredicate>
{
}
@end

@implementation TheBoxPredicateOnCategory


-(BOOL)does:(id)thiz match:(id)that
{
	NSNumber *thizCategoryId = [thiz objectForKey:@"category_id"];
	NSNumber *thatCategoryId = [that objectForKey:@"category_id"];
	
return [thizCategoryId isEqual:thatCategoryId];
}

-(BOOL)is:(id)thiz higherThan:(id)that
{
	NSNumber *thizCategoryId = [thiz objectForKey:@"category_id"];
	NSNumber *thatCategoryId = [that objectForKey:@"category_id"];
	
return [thizCategoryId intValue] > [thatCategoryId intValue];
}

@end


@implementation TheBoxPredicates

+(id<TheBoxPredicate>)newCategoryIdPredicate {
return [[TheBoxPredicateOnCategory alloc] init];
}

@end
