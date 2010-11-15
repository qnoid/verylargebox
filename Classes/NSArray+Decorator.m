/*
 *  Copyright 2010 The Box
 *  All rights reserved.
 *
 *  This file is part of TheBox
 *
 *  Created by Markos Charatzas <[firstname.lastname@gmail.com]> on 14/11/10.
 *  Contributor(s): .-
 */
#import "NSArray+Decorator.h"


@implementation NSArray (Decorator)

- (BOOL)isLast:(id)anObject{
return [self count] - 1 == [self indexOfObject:anObject];
}

-(id)next:(id)anObject{
	NSInteger index = [self indexOfObject:anObject];
return [self objectAtIndex:++index];	
}

@end
