/*
 *  Copyright 2010 The Box
 *  All rights reserved.
 *
 *  This file is part of TheBox
 *
 *  Created by Markos Charatzas <[firstname.lastname@gmail.com]> on 27/11/10.
 *  Contributor(s): .-
 */

#import "TheBoxUIRecycleStrategy.h"
#import "TheBoxRect.h"
#import "TheBoxUIRecycleStrategyMethod.h"
#import "PartiallyVisibleWithinX.h"
#import "PartiallyVisibleWithinY.h"
#import "UIView+TheBoxUIView.h"

@implementation TheBoxUIRecycleStrategy

+(TheBoxUIRecycleStrategy *)newPartiallyVisibleWithinX 
{
	PartiallyVisibleWithinX *method = [[PartiallyVisibleWithinX alloc]init];
	TheBoxUIRecycleStrategy *recycleStrategy = [[TheBoxUIRecycleStrategy alloc] initWith:method];
	[method release];
	
return recycleStrategy;	
}

+(TheBoxUIRecycleStrategy *)newPartiallyVisibleWithinY 
{
	PartiallyVisibleWithinY *method = [[PartiallyVisibleWithinY alloc]init];
	TheBoxUIRecycleStrategy *recycleStrategy = [[TheBoxUIRecycleStrategy alloc] initWith:method];
	[method release];
	
return recycleStrategy;	
}

- (void) dealloc
{
	[self.recycleMethod release];
	[self.recycledViews release];
	[super dealloc];
}


@synthesize recycleMethod;
@synthesize recycledViews;

-(id)initWith:(id<TheBoxUIRecycleStrategyMethod>) aRecycleMethod
{
	self = [super init];
	
	if (self) 
	{
		self.recycleMethod = aRecycleMethod;
		self.recycledViews = [[NSMutableSet alloc] init];
	}
	
	return self;
}

-(void)recycle:(NSArray *)views bounds:(CGRect) bounds
{	
	for (UIView *visibleView in views) 
	{
		if(![self.recycleMethod is:visibleView.frame visibleIn:bounds])
		{
			NSLog(@"recycle view %@", visibleView);
			[recycledViews addObject:visibleView];
			[visibleView removeFromSuperview];			
		}
	}
}

-(UIView *)dequeueReusableView
{
	UIView *view = [self.recycledViews anyObject];
    if (view) {
        [[view retain] autorelease];
        [self.recycledViews removeObject:view];
    }

	NSLog(@"dequeueReusableView %@", view);
	
return view;
}

@end
