/*
 *  Copyright 2010 The Box
 *  All rights reserved.
 *
 *  This file is part of TheBox
 *
 *  Created by Markos Charatzas <[firstname.lastname@gmail.com]> on 13/12/10.
 *  Contributor(s): .-
 */
#import "TheBoxSize.h"


@implementation TheBoxSize

@synthesize size;

-(id)initWithSize:(CGSize) theSize
{
	self = [super init];
	
	if (self) 
	{
		self.size = theSize;
	}
	
return self;
}

-(NSUInteger)minimumVisible:(CGRect) visibleBounds
{
	NSUInteger visibleWindowStart = CGRectGetMinX(visibleBounds);
	
return floorf(visibleWindowStart / self.size.width);
}

-(NSUInteger)maximumVisible:(CGRect) visibleBounds
{
	NSUInteger visibleWindowStart = CGRectGetMinX(visibleBounds);
	NSUInteger visibleWindowWidth = CGRectGetWidth(visibleBounds);
	
return ceilf((visibleWindowStart + visibleWindowWidth) / self.size.width);
}

@end
