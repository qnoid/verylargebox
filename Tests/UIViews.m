/*
 *  Copyright 2010 The Box
 *  All rights reserved.
 *
 *  This file is part of TheBox
 *
 *  Created by Markos Charatzas <[firstname.lastname@gmail.com]> on 13/12/10.
 *  Contributor(s): .-
 */
#import "UIViews.h"


@implementation UIViews

-(NSArray *)of:(NSArray *) rects
{
	NSMutableArray *views = [[[NSMutableArray alloc] init] autorelease];

	for (NSValue *value in rects) 
	{
		CGRect rect = [value CGRectValue];
		UIView *view = [[UIView alloc] initWithFrame:rect];
		
		[views addObject:view];
		
		[view release];
	}
	
return views;
}
@end
