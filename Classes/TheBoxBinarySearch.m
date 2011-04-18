/*
 *  Copyright 2010 TheBox
 *  All rights reserved.
 *
 *  This file is part of TheBox
 *
 *  Created by Markos Charatzas <[firstname.lastname@gmail.com]> on 16/04/2011.
 *  Contributor(s): .-
 */
#import "TheBoxBinarySearch.h"

@interface TheBoxBinarySearch ()
-(id)find:(id<TheBoxPredicate>)what on:(NSArray *)values between:(NSUInteger)start and:(NSUInteger) to;
@end


@implementation TheBoxBinarySearch

-(id)find:(id<TheBoxPredicate>)what on:(NSArray *)values between:(NSUInteger)start and:(NSUInteger) to
{
	
	while (start < to) 
	{
		NSUInteger index = (start + to) >> 1;
		
		id value = [values objectAtIndex:index];
		
		if ([what applies:value]) {
		return value;
		}

		if ([what isHigherThan:value]) {
			start = index + 1;
		}

		to = index - 1;
	}
	
	
return nil;
}

-(id)find:(id<TheBoxPredicate>)what on:(NSArray *)values{
return [self find:what on:values between:0 and:[values count]];
}

@end
