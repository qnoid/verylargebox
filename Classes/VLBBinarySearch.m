//
//  Copyright (c) 2010 (verylargebox.com). All rights reserved.
//  All rights reserved.
//
//  This file is part of TheBox
//
//  Created by Markos Charatzas on 16/04/2011.
//
//

#import "VLBBinarySearch.h"

@interface VLBBinarySearch ()
-(NSUInteger)find:(id)what on:(NSArray *)values between:(NSInteger)start and:(NSInteger) to;
@end


@implementation VLBBinarySearch

@synthesize predicate;



-(id)initWithPredicate:(id<VLBPredicate>) aPredicate
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
