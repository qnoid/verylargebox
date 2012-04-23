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
#import "PartiallyVisibleWithinX.h"
#import "PartiallyVisibleWithinY.h"

@implementation TheBoxUIRecycleStrategy

+(TheBoxUIRecycleStrategy *)newPartiallyVisibleWithinX 
{
	PartiallyVisibleWithinX *method = [[PartiallyVisibleWithinX alloc]init];
	TheBoxUIRecycleStrategy *recycleStrategy = [[TheBoxUIRecycleStrategy alloc] initWith:method];
	
return recycleStrategy;	
}

+(TheBoxUIRecycleStrategy *)newPartiallyVisibleWithinY 
{
	PartiallyVisibleWithinY *method = [[PartiallyVisibleWithinY alloc]init];
	TheBoxUIRecycleStrategy *recycleStrategy = [[TheBoxUIRecycleStrategy alloc] initWith:method];
	
return recycleStrategy;	
}


@synthesize recycleMethod;
@synthesize recycledViews;


-(id)initWith:(id<TheBoxUIRecycleStrategyMethod>) aRecycleMethod
{
	self = [super init];
	
	if (self) 
	{
		self.recycleMethod = aRecycleMethod;
		self.recycledViews = [NSMutableSet new];
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
    __strong UIView* copy = view;
    if (view) {
        [self.recycledViews removeObject:view];
    }

	NSLog(@"dequeueReusableView %@", view);
	
return copy;
}

@end
