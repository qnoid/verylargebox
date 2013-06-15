/*
 *  Copyright 2010 The Box
 *  All rights reserved.
 *
 *  This file is part of TheBox
 *
 *  Created by Markos Charatzas <[firstname.lastname@gmail.com]> on 13/12/10.
 *  Contributor(s): .-
 */
#import "VLBTestViews.h"

@implementation VLBTestViews

-(NSArray *)of:(NSArray *) rects
{
	NSMutableArray *views = [[NSMutableArray alloc] init];

	for (NSValue *value in rects) 
	{
		CGRect rect = [value CGRectValue];
		UIView *view = [[UIView alloc] initWithFrame:rect];
		
		[views addObject:view];
		
	}
	
return views;
}
@end
