/*
 *  Copyright 2010 The Box
 *  All rights reserved.
 *
 *  This file is part of TheBox
 *
 *  Created by Markos Charatzas <[firstname.lastname@gmail.com]> on 07/02/10.
 *  Contributor(s): .-
 */
#import "TheBoxUIScrollView.h"
#import "TheBoxUIRecycleStrategy.h"
#import "VisibleStrategy.h"
#import "TheBoxVisibleStrategy.h"
#import "TheBoxSize.h"
#import "TheBoxUIScrollViewDatasource.h"

@interface TheBoxUIScrollView ()
@property(nonatomic, retain) TheBoxUIRecycleStrategy *recycleStrategy;
@property(nonatomic, retain) id<VisibleStrategy> visibleStrategy;
@property(nonatomic, retain) UIView *contentView;
@end


@implementation TheBoxUIScrollView

+(TheBoxUIScrollView *) newVerticalScrollView:(CGRect)frame viewsOf:(CGFloat)height
{
	TheBoxVisibleStrategy *visibleStrategy = 
		[TheBoxVisibleStrategy newVisibleStrategyOn:
			[[TheBoxSize newHeight:height] autorelease]];
	
	TheBoxUIRecycleStrategy *recycleStrategy = 
		[TheBoxUIRecycleStrategy newPartiallyVisibleWithinY];

	TheBoxUIScrollView *scrollView = 
		[TheBoxUIScrollView 
			newScrollView:frame
			recycleStrategy:recycleStrategy 
			visibleStrategy:visibleStrategy];
	
	[visibleStrategy release];
	[recycleStrategy release];	

return scrollView;
}

+(TheBoxUIScrollView *) newHorizontalScrollView:(CGRect)frame viewsOf:(CGFloat)width
{
	TheBoxVisibleStrategy *visibleStrategy = 
		[TheBoxVisibleStrategy newVisibleStrategyOn:
			[[TheBoxSize newWidth:width] autorelease]];
	
	TheBoxUIRecycleStrategy *recycleStrategy = 
		[TheBoxUIRecycleStrategy newPartiallyVisibleWithinX];
	
	TheBoxUIScrollView *scrollView = 
		[TheBoxUIScrollView 
		 newScrollView:frame
		 recycleStrategy:recycleStrategy 
		 visibleStrategy:visibleStrategy];
	
	[visibleStrategy release];
	[recycleStrategy release];	
	
return scrollView;
}

+(TheBoxUIScrollView *) newScrollView:(CGRect)aFrame recycleStrategy:(TheBoxUIRecycleStrategy *)aRecycleStrategy visibleStrategy:(id<VisibleStrategy>) aVisibleStrategy;
{
	TheBoxUIScrollView *scrollView = [[TheBoxUIScrollView alloc] initWithFrame:aFrame];
	scrollView.recycleStrategy = aRecycleStrategy;
	scrollView.visibleStrategy = aVisibleStrategy;	
	scrollView.visibleStrategy.delegate = scrollView;	
	
return scrollView;
}

@synthesize datasource;
@synthesize scrollViewDelegate;
@synthesize theBoxSize;
@synthesize contentView;
@synthesize recycleStrategy;
@synthesize visibleStrategy;

#pragma mark private fields

TheBoxUIRecycleStrategy *recycleStrategy;
id<VisibleStrategy> visibleStrategy;
TheBoxSize *theBoxSize;

/* Apparently a UIScrollView needs another view as its content view else it messes up the scrollers.
 * Interface Builder uses a private _contentView instead.
 *
 */
UIView *contentView;

- (void) dealloc
{
	[theBoxSize release];
	[recycleStrategy release];
	[visibleStrategy release];
	[contentView release];
	[super dealloc];
}

- (id) initWithFrame:(CGRect) frame;
{
	self = [super initWithFrame:frame];
	if (self) 
	{
		TheBoxSize *aBoxSize = [[TheBoxSize alloc] initWithSize:self.frame.size];				

		UIView *aContentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
		
		self.theBoxSize = aBoxSize;
		self.contentView = aContentView;
		[super addSubview:self.contentView];
		
		[aContentView release];
		[aBoxSize release];
	}
return self;
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

/**
 * Calculates the content size.
 * Recycles any visible views within its bounds
 * Removes any non visible views
 * Shows views within bounds
 */
-(void) layoutSubviews
{
	self.contentSize = [self.scrollViewDelegate contentSizeOf:self withData:datasource];
	
	NSLog(@"frame %@", NSStringFromCGRect(self.frame));	
	NSLog(@"contentSize %@", NSStringFromCGSize(self.contentSize));	
	NSLog(@"layoutSubviews on bounds %@", NSStringFromCGRect([self bounds]));	

    CGRect bounds = [self bounds];
    
	/*
	 * Avoid using bounds outside fo the content (e.g. when bouncing off a view)
	 */
	CGRect visibleBounds = CGRectMake(MIN(self.contentSize.width - self.frame.size.width, bounds.origin.x), MIN(self.contentSize.height - self.frame.size.height, bounds.origin.y), bounds.size.width, bounds.size.height);

	NSLog(@"layoutSubviews on visibleBounds %@", NSStringFromCGRect(visibleBounds));	
    
	[self recycleVisibleViewsWithinBounds:visibleBounds];
	[self removeRecycledFromVisibleViews];	
	[self showViewsWithinBounds:visibleBounds];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	CGRect bounds = [scrollView bounds];

	/*
	 * Avoid using bounds outside fo the content (e.g. when bouncing off a view)
	 */
	CGRect visibleBounds = CGRectMake(MIN(self.contentSize.width - self.frame.size.width, bounds.origin.x), MIN(self.contentSize.height - self.frame.size.height, bounds.origin.y), bounds.size.width, bounds.size.height);

	NSLog(@"scrollViewDidScroll on visibleBounds %@", NSStringFromCGRect(visibleBounds));	
	NSLog(@"scrollViewDidScroll on bounds %@", NSStringFromCGRect(bounds));	
	[self recycleVisibleViewsWithinBounds:bounds];
	[self removeRecycledFromVisibleViews];	
	[self showViewsWithinBounds:bounds];
}

/*
 * When called, the scrollView needs a new instance of TheBoxVisibleStrategy.
 * The reason being that TheBoxVisibleStrategy#MINIMUM_VISIBLE_INDEX and
 * TheBoxVisibleStrategy#MAXIMUM_VISIBLE_INDEX are now invalidated as well as 
 * any visible sections since each one of them might have changed in content size
 * and or cells it displays.
 */
-(void) setNeedsLayout
{
	NSArray* subviews = [self.contentView subviews];
	
	for (UIView* view in subviews) {
		[view removeFromSuperview];
	}
	
	
	/* For horizontal scrolling must reset to visible strategy of
	 *
	 * TheBoxVisibleStrategy *visibleStrategy =
	 *		[TheBoxVisibleStrategy newVisibleStrategyOnWidth:
	 *			CGSizeMake(CELL_FRAME_WIDTH, CELL_FRAME_HEIGHT)];
	 */	
	id<TheBoxDimension> height = [TheBoxSize newHeight:196];
	
	TheBoxVisibleStrategy *aVisibleStrategy = 
		[TheBoxVisibleStrategy newVisibleStrategyOn:height];
	
	aVisibleStrategy.delegate = self;
	
	self.visibleStrategy = aVisibleStrategy;
	
	[aVisibleStrategy release];
	[height release];
	[self flashScrollIndicators];	
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

-(UIView *)shouldBeVisible:(int)index
{
	UIView *view = [self.datasource viewOf:self atIndex:index];
	
	/*
	 * Adding subviews to self places them side by side which
	 * causes scrollers to appear and disappear as if overlapping.
	 * Thus another scrollview is used as an mediator.
	 */	
	[self.contentView addSubview:view];
return view;
}

@end
