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
@property(nonatomic, strong) TheBoxUIRecycleStrategy *recycleStrategy;
@property(nonatomic, strong) id<VisibleStrategy> visibleStrategy;
/* Apparently a UIScrollView needs another view as its content view else it messes up the scrollers.
 * Interface Builder uses a private _contentView instead.
 */
@property(nonatomic, strong) UIView *contentView;
@end


@implementation TheBoxUIScrollView

+(TheBoxUIScrollView *) newVerticalScrollView:(CGRect)frame viewsOf:(CGFloat)height
{
	TheBoxVisibleStrategy *visibleStrategy = 
        [TheBoxVisibleStrategy newVisibleStrategyOnHeight:height];
	
	TheBoxUIRecycleStrategy *recycleStrategy = 
		[TheBoxUIRecycleStrategy newPartiallyVisibleWithinY];

	TheBoxUIScrollView *scrollView = 
		[TheBoxUIScrollView 
			newScrollView:frame
			recycleStrategy:recycleStrategy 
			visibleStrategy:visibleStrategy];
	

return scrollView;
}

+(TheBoxUIScrollView *) newHorizontalScrollView:(CGRect)frame viewsOf:(CGFloat)width
{
	TheBoxVisibleStrategy *visibleStrategy = 
        [TheBoxVisibleStrategy newVisibleStrategyOnWidth:width];
	
	TheBoxUIRecycleStrategy *recycleStrategy = 
		[TheBoxUIRecycleStrategy newPartiallyVisibleWithinX];
	
	TheBoxUIScrollView *scrollView = 
		[TheBoxUIScrollView 
		 newScrollView:frame
		 recycleStrategy:recycleStrategy 
		 visibleStrategy:visibleStrategy];
	
	
return scrollView;
}

+(TheBoxUIScrollView *) newScrollView:(CGRect)aFrame recycleStrategy:(TheBoxUIRecycleStrategy *)aRecycleStrategy visibleStrategy:(id<VisibleStrategy>) aVisibleStrategy;
{
	TheBoxUIScrollView *scrollView = [[TheBoxUIScrollView alloc] initWithFrame:aFrame];
	scrollView.recycleStrategy = aRecycleStrategy;
	scrollView.visibleStrategy = aVisibleStrategy;	
	scrollView.visibleStrategy.delegate = scrollView;	
	scrollView.clipsToBounds = NO;

return scrollView;
}

@synthesize datasource;
@synthesize scrollViewDelegate;
@synthesize theBoxSize;
@synthesize contentView;
@synthesize recycleStrategy;
@synthesize visibleStrategy;

#pragma mark private fields

/* Apparently a UIScrollView needs another view as its content view else it messes up the scrollers.
 * Interface Builder uses a private _contentView instead.
 *
 */
UIView *contentView;

- (id) initWithFrame:(CGRect) frame;
{
	self = [super initWithFrame:frame];
	if (self) 
	{
		self.theBoxSize = [[TheBoxSize alloc] initWithSize:self.frame.size];
		self.contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
		[self addSubview:self.contentView];
	}
return self;
}


-(void)recycleVisibleViewsWithinBounds:(CGRect)bounds {
	[self.recycleStrategy recycle:[self.visibleStrategy.visibleViews allObjects] bounds:bounds];		
}

-(void)removeRecycledFromVisibleViews {
	[self.visibleStrategy.visibleViews minusSet:self.recycleStrategy.recycledViews];	
}

/**
 * The Visible strategy uses TheBoxDimension which will ceilf the bounds as to catch any partially visible cells.
 * However, reaching at the edge of the scrollview, will cause the bounds to include the "bouncing" part of the view which 
 * shouldn't be taken into account as something partially visible. Therefore need to keep the width at a maximum.
 *
 * Visible bounds should be at maximum the original width and height
 *
 * @see TheBoxDimension#maximumVisible:
 */
-(void)displayViewsWithinBounds:(CGRect)bounds
{
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
	[self.visibleStrategy maximumVisibleIndexShould:ceilMaximumVisibleIndexAt([self.datasource numberOfViews:self])];
	
    NSLog(@"%s", __PRETTY_FUNCTION__);
	NSLog(@"frame %@", NSStringFromCGRect(self.frame));	
	NSLog(@"contentSize %@", NSStringFromCGSize(self.contentSize));	
	NSLog(@"layoutSubviews on bounds %@", NSStringFromCGRect([self bounds]));	
    
    CGRect bounds = [self bounds];
        
	[self recycleVisibleViewsWithinBounds:bounds];
	[self removeRecycledFromVisibleViews];	
	[self displayViewsWithinBounds:bounds];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	CGRect bounds = [scrollView bounds];

	NSLog(@"scrollViewDidScroll on bounds %@", NSStringFromCGRect(bounds));	

	[self recycleVisibleViewsWithinBounds:bounds];
	[self removeRecycledFromVisibleViews];	
	[self displayViewsWithinBounds:bounds];
}

-(NSUInteger)indexOf:(CGPoint)point {
    return [self.visibleStrategy minimumVisible:point];
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
    [super setNeedsLayout];
	NSArray* subviews = [self.contentView subviews];
	
	for (UIView* view in subviews) {
		[view removeFromSuperview];
	}
	
	TheBoxVisibleStrategy *aVisibleStrategy = 
		[TheBoxVisibleStrategy newVisibleStrategyFrom:self.visibleStrategy];
	
	aVisibleStrategy.delegate = self;
	
	self.visibleStrategy = aVisibleStrategy;
	
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
    
    NSLog(@"added as subview %@, with bounds %@", view, NSStringFromCGRect(view.bounds));
return view;
}

@end
