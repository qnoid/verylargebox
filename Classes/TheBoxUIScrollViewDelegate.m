/*
 *  Copyright 2010 The Box
 *  All rights reserved.
 *
 *  This file is part of TheBox
 *
 *  Created by Markos Charatzas <[firstname.lastname@gmail.com]> on 07/02/10.
 *  Contributor(s): .-
 */
#import "TheBoxUIScrollViewDelegate.h"
#import "TheBoxUIRecycleStrategy.h"
#import "VisibleStrategy.h"

@implementation TheBoxUIScrollViewDelegate

+(TheBoxUIScrollViewDelegate *) newScrollView:(CGRect)aFrame recycleStrategy:(TheBoxUIRecycleStrategy *)aRecycleStrategy visibleStrategy:(id<VisibleStrategy>) aVisibleStrategy;
{
	TheBoxUIScrollViewDelegate *scrollView = [[TheBoxUIScrollViewDelegate alloc] initWithFrame:aFrame];
	scrollView.recycleStrategy = aRecycleStrategy;
	scrollView.visibleStrategy = aVisibleStrategy;	
	
return scrollView;
}

@synthesize recycleStrategy;
@synthesize visibleStrategy;

#pragma mark private fields

/* Apparently a UIScrollView needs another view as its content view else it messes up the scrollers.
 * Interface Builder uses a private _contentView instead.
 *
 */
UIView *contentView;

- (void) dealloc
{
	[self.recycleStrategy release];
	[self.visibleStrategy release];
	[super dealloc];
}

-(void)recycleVisibleViewsWithinBounds:(CGRect)bounds {
	[self.recycleStrategy recycle:[self.visibleStrategy.visibleViews allObjects] bounds:bounds];		
}

-(void)removeRecycledFromVisibleViews {
	[self.visibleStrategy.visibleViews minusSet:self.recycleStrategy.recycledViews];	
}

-(void)showViewsWithinBounds:(CGRect)bounds{
	[self.visibleStrategy willAppear:bounds];	
}

-(void) layoutSubviews
{
	NSLog(@"layoutSubviews on bounds %@", NSStringFromCGRect([self bounds]));	
	CGRect visibleBounds = [self bounds];
	[self recycleVisibleViewsWithinBounds:visibleBounds];
	[self removeRecycledFromVisibleViews];	
	[self showViewsWithinBounds:visibleBounds];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	CGRect visibleBounds = [scrollView bounds];

	/*
	 * Avoid using bounds outside fo the content (e.g. when bouncing off a view)
	 */
	CGRect bounds = CGRectMake(MAX(0, visibleBounds.origin.x), MAX(0, visibleBounds.origin.y), visibleBounds.size.width, visibleBounds.size.height);

	NSLog(@"scrollViewDidScroll on visibleBounds %@", NSStringFromCGRect(visibleBounds));	
	NSLog(@"scrollViewDidScroll on bounds %@", NSStringFromCGRect(bounds));	
	[self recycleVisibleViewsWithinBounds:bounds];
	[self removeRecycledFromVisibleViews];	
	[self showViewsWithinBounds:bounds];
}

-(void) setNeedsLayout
{
	NSArray* subviews = [self subviews];
	
	for (UIView* view in subviews) {
		[view removeFromSuperview];
	}
}

/*
 * Need to remove dequeued view from superview since it's not used anymore
 */
-(UIView*)dequeueReusableView 
{
	UIView* view = [self.recycleStrategy dequeueReusableView];	
	[view removeFromSuperview];
return view;
}

@end
