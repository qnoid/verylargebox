//
//  Copyright 2010 The Box
//  All rights reserved.
//
//  This file is part of TheBox
//
//  Created by Markos Charatzas on 14/11/10.
//
//

#import "NSArray+VLBDecorator.h"


@implementation NSArray (VLBDecorator)

- (BOOL)vlb_isEmpty {
    return [self count] == 0;
}

- (BOOL)vlb_isLast:(id)anObject{
return [self count] - 1 == [self indexOfObject:anObject];
}

-(id)vlb_next:(id)anObject{
	NSInteger index = [self indexOfObject:anObject];
return [self objectAtIndex:++index];	
}

@end
