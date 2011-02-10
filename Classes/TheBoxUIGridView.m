/*
 *  Copyright 2010 The Box
 *  All rights reserved.
 *
 *  This file is part of TheBox
 *
 *  Created by Markos Charatzas <[firstname.lastname@gmail.com]> on 8/11/10.
 *  Contributor(s): .-
 */
#import "TheBoxUISectionViewBuilder.h"
#import "TheBoxUIGridView.h"
#import "TheBoxUISectionView.h"
#import "TheBoxUICell.h"
#import "TheBoxUIGridViewDatasource.h"
#import "TheBoxUIRecycleStrategy.h"
#import "TheBoxUISectionVisibleStrategy.h"
#import "TheBoxUIRecycleView.h"

@interface TheBoxUIGridView ()
-(UIView *) dequeueReusableSection;

/*
 * @param section the section index
 * @param columns the number of columns in the section
 * @return the frame required to display the view
 */
-(CGRect) frame:(NSUInteger)section noOfColumns:(NSUInteger) columns;
@end

static const int SECTION_FRAME_X = 0;
static const int SECTION_FRAME_WIDTH = 320;
static const int SECTION_FRAME_HEIGHT = 196;
static const int COLUMN_FRAME_WIDTH = 160;

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
+(TheBoxUIGridView *) newGridView:(CGRect) frame datasource:(id<TheBoxUIGridViewDatasource>)aDatasource
{
	TheBoxUIGridView *gridView = [[TheBoxUIGridView alloc] initWithFrame:frame];
	gridView.bounces = NO;
	gridView.pagingEnabled = YES;
	gridView.numberOfSectionsPerGridView = gridView.frame.size.height / SECTION_FRAME_HEIGHT;
	gridView.datasource = aDatasource;
	
	NSUInteger numberOfSections = [gridView numberOfSections];
	
	NSLog(@"number of sections: %d number of sections per grid view %d", numberOfSections, gridView.numberOfSectionsPerGridView);

	CGSize contentSize = CGSizeMake(
									frame.size.width, 
									(float)numberOfSections / (float)gridView.numberOfSectionsPerGridView * frame.size.height);
	
	gridView.contentSize = contentSize;
	
	NSLog(@"content size of grid view %@", NSStringFromCGSize(gridView.contentSize));
	
return gridView;
}

@synthesize subview;
@synthesize sectionBuilder;
@synthesize datasource;
@synthesize numberOfSectionsPerGridView;
@synthesize sectionSize;

- (void) dealloc
{
	[self.subview release];
	self.delegate = nil;
	[self.sectionBuilder release];
	[super dealloc];
}

-(id) initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	
	if (self) {
		self.delegate = self;
		
		TheBoxUIRecycleStrategy *recycleStrategy = [TheBoxUIRecycleStrategy newPartiallyVisibleWithinY];
		TheBoxUISectionVisibleStrategy *visibleStrategy = [[TheBoxUISectionVisibleStrategy alloc] init];
		visibleStrategy.delegate = self;
				
		TheBoxUIRecycleView *recycleView = [TheBoxUIRecycleView newRecycledView:recycleStrategy visibleStrategy:visibleStrategy];
		recycleView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
		
		self.subview = recycleView;
		[self addSubview:subview];
		[recycleView release];
		[visibleStrategy release];
		[recycleStrategy release];
		
		self.sectionSize = CGSizeMake(SECTION_FRAME_WIDTH, SECTION_FRAME_HEIGHT);
	}
	
return self;
}

-(void) layoutSubviews
{    
	NSLog(@"layoutSubviews on grid");	
    CGRect visibleBounds = [self bounds];
	
	[self.subview size:self.sectionSize bounds:visibleBounds];	
	
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	NSLog(@"scrollViewDidScroll on grid");
    CGRect visibleBounds = [self bounds];
	
	NSLog(@"frame size of subview %@", NSStringFromCGRect(self.subview.frame));

	
	[self.subview size:self.sectionSize bounds:visibleBounds];	
}

-(UIView *)dequeueReusableSection {	
return [self.subview dequeueReusableView];
}

-(UIView *)shouldBeVisible:(int)index
{
	UIView *view = [self viewForSection:index];
	[self.subview addSubview:view];
return view;
}

-(CGRect) frame:(NSUInteger)section noOfColumns:(NSUInteger) columns {
return CGRectMake(SECTION_FRAME_X, SECTION_FRAME_HEIGHT * section, MIN(columns * COLUMN_FRAME_WIDTH, SECTION_FRAME_WIDTH), SECTION_FRAME_HEIGHT);	
}

-(UIView *)viewForSection:(NSInteger)section
{
	NSLog(@"asking for section %d", section);

	UIView *view = [self dequeueReusableSection];
	
    if (view == nil) {
		NSLog(@"no available section to dequeue, creating section: %d", section);
		view = [[self.sectionBuilder newSection:section] autorelease];
	}
	
	((TheBoxUISectionView *)view).index = section;
	view.frame = [self frame:section noOfColumns:[sectionBuilder numberOfColumnsInSection:section]];
	((TheBoxUISectionView *)view).contentOffset = CGPointZero;
	
	/*
	 * Because views are being recycled, this is required so as #layoutSubviews 
	 * is called to update what's visible for the new section
	 */
	[view setNeedsLayout];
	NSLog(@"view %@", view);
		
return view;
}

- (NSUInteger)numberOfSections{
return [self.datasource numberOfSectionsInGridView:self];
}

@end
