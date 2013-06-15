/*
 *  Copyright 2010 The Box
 *  All rights reserved.
 *
 *  This file is part of TheBox
 *
 *  Created by Markos Charatzas (@qnoid) on 27/11/10.
 *  Contributor(s): .-
 */

#import "TheBoxUIRecycleStrategy.h"

@implementation TheBoxUIRecycleStrategy

@synthesize recycledViews;


-(id)init
{
	self = [super init];
	
	if (self) 
	{
		self.recycledViews = [NSMutableSet new];
	}
	
	return self;
}

-(void)recycle:(NSArray *)views {
    [recycledViews addObjectsFromArray:views];
}

-(void)recycle:(NSArray *)views bounds:(CGRect) bounds
{	
	for (UIView *visibleView in views) 
	{
		if(!CGRectIntersectsRect(visibleView.frame, bounds))
		{
			DDLogVerbose(@"recycle view %@", visibleView);
			[recycledViews addObject:visibleView];
			[visibleView removeFromSuperview];			
		}
	}
}

-(UIView *)dequeueReusableView
{
	UIView *view = [self.recycledViews anyObject];
    __strong UIView* copy = view;
    if (view) {
        [self.recycledViews removeObject:view];
    }

	DDLogVerbose(@"dequeueReusableView %@", view);
	
return copy;
}

@end
