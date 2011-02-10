/*
 *  Copyright 2010 The Box
 *  All rights reserved.
 *
 *  This file is part of TheBox
 *
 *  Created by Markos Charatzas <[firstname.lastname@gmail.com]> on 07/02/10.
 *  Contributor(s): .-
 */
#import "TheBoxUIRecycleView.h"
#import "TheBoxUIRecycleStrategy.h"
#import "VisibleStrategy.h"

@interface TheBoxUIRecycleView()
-(id) initWithFrame:(CGRect)frame;
-(void)recycleVisibleViewsWithinBounds:(CGRect)bounds;
-(void)removeRecycledFromVisibleViews;
-(void)showViewsOfSize:(CGSize)size withinBounds:(CGRect)bounds;
@end

@implementation TheBoxUIRecycleView

+(TheBoxUIRecycleView *) newRecycledView:(TheBoxUIRecycleStrategy *)aRecycleStrategy visibleStrategy:(id<VisibleStrategy>) aVisibleStrategy
{
	TheBoxUIRecycleView *recycledView = [[TheBoxUIRecycleView alloc] initWithFrame:CGRectZero];
	recycledView.recycleStrategy = aRecycleStrategy;
	recycledView.visibleStrategy = aVisibleStrategy;	
	
return recycledView;
}

@synthesize recycleStrategy;
@synthesize visibleStrategy;

- (void) dealloc
{
	[self.recycleStrategy release];
	[self.visibleStrategy release];
	[super dealloc];
}


-(id) initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];

	if (self) {
	}
	
return self;
}

-(void)recycleVisibleViewsWithinBounds:(CGRect)bounds {
	[self.recycleStrategy recycle:self views:[self.visibleStrategy.visibleViews allObjects] bounds:bounds];		
}

-(void)removeRecycledFromVisibleViews {
	[self.visibleStrategy.visibleViews minusSet:self.recycleStrategy.recycledViews];	
}

-(void)showViewsOfSize:(CGSize)size withinBounds:(CGRect)bounds{
	[self.visibleStrategy willAppear:size within:bounds];	
}

-(void) size:(CGSize) size bounds:(CGRect)bounds
{
	[self recycleVisibleViewsWithinBounds:bounds];
	[self removeRecycledFromVisibleViews];
	[self showViewsOfSize:size withinBounds:bounds];
}

-(UIView *)dequeueReusableView {
return [self.recycleStrategy dequeueReusableView];	
}

-(void) didRecycle:(TheBoxUIRecycleStrategy *)recycleStrategy
{
	[self.visibleStrategy reset];
}

@end
