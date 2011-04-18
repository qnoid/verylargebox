/*
 *  Copyright 2010 The Box
 *  All rights reserved.
 *
 *  This file is part of TheBox
 *
 *  Created by Markos Charatzas <[firstname.lastname@gmail.com]> on 26/11/10.
 *  Contributor(s): .-
 */
#import "TheBoxVisibleStrategy.h"

#import "TheBoxUIRecycleStrategy.h"
#import "TheBoxUISectionView.h"
#import "TheBoxUICell.h"
#import "TheBoxUISectionViewDataSource.h"
#import "TheBoxBundle.h"
#import "TheBoxUIScrollViewDelegate.h"
#import "UIView+TheBoxUIView.h"

@interface TheBoxUISectionView ()
@property(nonatomic, assign) TheBoxSize *theBoxSize;
@property(nonatomic, assign) TheBoxUIScrollViewDelegate *contentView;
@end



@implementation TheBoxUISectionView

/*
 * Relative to the view
 */
static const int CELL_FRAME_Y = 0;

static const int CELL_FRAME_WIDTH = 160;
static const int CELL_FRAME_HEIGHT = 196;


@synthesize theBoxSize;
@synthesize contentView;


@synthesize datasource;
@synthesize index;

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
	
	if (self) {
		
		self.theBoxSize = [[TheBoxSize alloc] initWithSize:self.frame.size];
		
		TheBoxUIRecycleStrategy *recycleStrategy = [TheBoxUIRecycleStrategy newPartiallyVisibleWithinX];
		TheBoxVisibleStrategy *visibleStrategy = [TheBoxVisibleStrategy newVisibleStrategyOnWidth:CGSizeMake(CELL_FRAME_WIDTH, CELL_FRAME_HEIGHT)];
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

-(void) layoutSubviews
{	
	NSLog(@"layoutSubviews on section: %d", index);
	[super layoutSubviews];
	self.contentSize = [self.theBoxSize 
								   contentSizeOf:CELL_FRAME_WIDTH 
								   ofColumns:[self.datasource numberOfColumnsInSection:self.index]];
}

-(UIView *)dequeueReusableCell {
return [self.contentView dequeueReusableView];
}

-(UIView *)shouldBeVisible:(int)column
{
	UIView *view = [self.datasource sectionView:self cellForIndex:column];
		
	/*
	 * Adding subviews to self places them side by side which
	 * causes scrollers to appear and disappear as if overlapping.
	 * Thus another scrollview is used as an mediator.
	 */		
	[self.contentView addSubview:view];
	
return view;
}

-(void) setNeedsLayout
{
	[super setNeedsLayout];
	[self.contentView setNeedsLayout];

	TheBoxVisibleStrategy *visibleStrategy = [TheBoxVisibleStrategy newVisibleStrategyOnWidth:CGSizeMake(CELL_FRAME_WIDTH, CELL_FRAME_HEIGHT)];
	visibleStrategy.delegate = self;
	
	self.contentView.visibleStrategy = visibleStrategy;
	
	[visibleStrategy release];
	[self flashScrollIndicators];
}

-(NSUInteger) hash{
return index;
}

-(BOOL) isEqual:(id)object
{
	if (self == object) {
		return YES;
	}
	
	if (![object isKindOfClass:[TheBoxUISectionView class]]) {
		return NO;
	}
		  
	TheBoxUISectionView* that = (TheBoxUISectionView*)object;

return self.index == that.index;
}

@end
