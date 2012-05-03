/*
 *  Copyright 2010 The Box
 *  All rights reserved.
 *
 *  This file is part of TheBox
 *
 *  Created by Markos Charatzas (@qnoid) on 14/11/10.
 *  Contributor(s): .-
 */
#import "NSArray+Decorator.h"


@implementation NSArray (Decorator)

- (BOOL)tbIsEmpty{
    return [self count] == 0;
}

- (BOOL)isLast:(id)anObject{
return [self count] - 1 == [self indexOfObject:anObject];
}

-(id)next:(id)anObject{
	NSInteger index = [self indexOfObject:anObject];
return [self objectAtIndex:++index];	
}

@end
