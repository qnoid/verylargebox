/*
 *  Copyright 2010 The Box
 *  All rights reserved.
 *
 *  This file is part of TheBox
 *
 *  Created by Markos Charatzas <[firstname.lastname@gmail.com]> on 8/11/10.
 *  Contributor(s): .-
 */
#import "TheBoxSize.h"
#import "TheBoxUIGridView.h"
#import "TheBoxUISectionView.h"
#import "TheBoxUICell.h"
#import "TheBoxUIGridViewDatasource.h"
#import "TheBoxUIRecycleStrategy.h"
#import "TheBoxVisibleStrategy.h"
#import "TheBoxUIScrollViewDelegate.h"

@interface TheBoxUIGridView ()
@property(nonatomic, assign) TheBoxSize *theBoxSize;
@property(nonatomic, assign) TheBoxUIScrollViewDelegate *contentView;
@end

/*
 * The grid is implemented by using a fixed width and a variable height to allow scrolling
 * across rows. Each row is an instance of TheBoxUISectionView.
 *
 *
 */
@implementation TheBoxUIGridView

/**
 * Create a new grid view with the given frame
 * Calculate the number of sections per grid view
 * Set always bounce horizontal to NO
 * Set the datasource
 * Calculate the content size based on the number of sections
 *
 *
 * @post the content size will have a
 *		width = frame.width
 *		height = number of sections / how many visible at a time times frame.height
 */
+(TheBoxUIGridView *) newGridView:(CGRect) frame datasource:(id<TheBoxUIGridViewDatasource>)aDatasource delegate:(id<TheBoxUIGridViewDelegate>)aDelegate
{
	TheBoxUIGridView *gridView = [[TheBoxUIGridView alloc] initWithFrame:frame];
//	gridView.bounces = NO;
	gridView.datasource = aDatasource;
	gridView.gridViewDelegate = aDelegate;
	
return gridView;
}

@synthesize theBoxSize;
@synthesize contentView;
@synthesize datasource;
@synthesize gridViewDelegate;


#pragma mark private fields
TheBoxUIScrollViewDelegate *contentView;

- (void) dealloc
{
	[self.theBoxSize release];	
	self.delegate = nil;
	[super dealloc];
}

-(id) initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	
	if (self) 
	{
		self.theBoxSize = [[TheBoxSize alloc] initWithSize:self.frame.size];				
		
		TheBoxUIRecycleStrategy *recycleStrategy = [TheBoxUIRecycleStrategy newPartiallyVisibleWithinY];
		TheBoxVisibleStrategy *visibleStrategy = [TheBoxVisibleStrategy newVisibleStrategyOnHeight:CGSizeMake(320, 196)];
		visibleStrategy.delegate = self;
		
		TheBoxUIScrollViewDelegate *scrollViewDelegate = [TheBoxUIScrollViewDelegate 
													 newScrollView:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) 
													 recycleStrategy:recycleStrategy 
													 visibleStrategy:visibleStrategy];
		
		self.contentView = scrollViewDelegate;
		self.delegate = self.contentView;
		[self addSubview:self.contentView];
		[scrollViewDelegate release];		
		[visibleStrategy release];
		[recycleStrategy release];
	}
	
return self;
}

/**
 * Calculates the content size
 */
-(void) layoutSubviews
{    
	NSLog(@"layoutSubviews on grid");	
	[super layoutSubviews];
	
	self.contentSize = [self.theBoxSize 
						   contentSizeOf:[self.gridViewDelegate whatRowHeight:self] 
						   ofRows:[self.datasource numberOfSectionsInGridView:self]];
}

-(UIView *)dequeueReusableSection {
return [self.contentView dequeueReusableView];
}

-(UIView *)shouldBeVisible:(int)index
{
	UIView *view = [self.datasource gridView:self sectionForIndex:index];
	
	/*
	 * Adding subviews to self places them side by side which
	 * causes scrollers to appear and disappear as if overlapping.
	 * Thus another scrollview is used as an mediator.
	 */	
	[self.contentView addSubview:view];
return view;
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
	[self.contentView setNeedsLayout];
	
	TheBoxVisibleStrategy *visibleStrategy = [TheBoxVisibleStrategy newVisibleStrategyOnHeight:CGSizeMake(320, 196)];
	visibleStrategy.delegate = self;

	self.contentView.visibleStrategy = visibleStrategy;
	
	[visibleStrategy release];
	[self flashScrollIndicators];
}

@end
