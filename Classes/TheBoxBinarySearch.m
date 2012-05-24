/*
 *  Copyright 2010 TheBox
 *  All rights reserved.
 *
 *  This file is part of TheBox
 *
 *  Created by Markos Charatzas (@qnoid) on 16/04/2011.
 *  Contributor(s): .-
 */
#import "TheBoxBinarySearch.h"

@interface TheBoxBinarySearch ()
-(NSUInteger)find:(id)what on:(NSArray *)values between:(NSInteger)start and:(NSInteger) to;
@end


@implementation TheBoxBinarySearch

@synthesize predicate;



-(id)initWithPredicate:(id<TheBoxPredicate>) aPredicate
{
    self = [super init];
    
    if (self) {
        self.predicate = aPredicate;
    }
    
return self;
}

-(NSUInteger)find:(id)what on:(NSArray *)values between:(NSInteger)start and:(NSInteger) to
{
	
	while (start <= to) 
	{
		NSUInteger index = (start + to) >> 1;
		
		id value = [values objectAtIndex:index];
		
		if ([self.predicate does:value match:what]) {
		return index;
		}

		if ([self.predicate is:what higherThan:value]) {
			start = index + 1;
		}
        else{
            to = index - 1;           
        }

	}
	
return NSNotFound;
}

-(NSUInteger)find:(id) what on:(NSArray *)values{
return [self find:what on:values between:0 and:[values count] - 1];
}

@end
