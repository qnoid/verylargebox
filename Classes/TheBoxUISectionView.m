/*
 *  Copyright 2010 The Box
 *  All rights reserved.
 *
 *  This file is part of TheBox
 *
 *  Created by Markos Charatzas <[firstname.lastname@gmail.com]> on 26/11/10.
 *  Contributor(s): .-
 */
#import "TheBoxUIRecycleStrategy.h"
#import "TheBoxUISectionView.h"
#import "TheBoxUICell.h"
#import "TheBoxUICellVisibleStrategy.h"
#import "TheBoxUISectionViewDataSource.h"
#import "TheBoxBundle.h"
#import "TheBoxUIRecycleView.h"

@interface TheBoxUISectionView ()
-(UIView *)dequeueReusableCell;
-(CGRect) cellFrame:(NSUInteger) column;
@end



@implementation TheBoxUISectionView

/*
 * Relative to the view
 */
static const int CELL_FRAME_Y = 0;

static const int CELL_FRAME_WIDTH = 160;
static const int CELL_FRAME_HEIGHT = 196;

@synthesize subview;
@synthesize datasource;
@synthesize index;
@synthesize currentCellIndex;
@synthesize cellSize;
@synthesize numberOfColumnsPerSectionView;

- (void) dealloc
{
	[self.subview release];
	self.datasource = nil;
	self.delegate = nil;
	[super dealloc];
}

-(id) initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	
	if (self) {
		self.delegate = self;
		
		TheBoxUIRecycleStrategy *recycleStrategy = [TheBoxUIRecycleStrategy newPartiallyVisibleWithinX];
		TheBoxUICellVisibleStrategy *visibleStrategy = [[TheBoxUICellVisibleStrategy alloc] init];
		visibleStrategy.delegate = self;

		TheBoxUIRecycleView *recycleView = [TheBoxUIRecycleView newRecycledView:recycleStrategy visibleStrategy:visibleStrategy];
		
		self.subview = recycleView;
		[self addSubview:subview];
		[recycleView release];
		[visibleStrategy release];
		[recycleStrategy release];
		
		self.cellSize = CGSizeMake(CELL_FRAME_WIDTH, CELL_FRAME_HEIGHT);
	}
	
return self;	
}

-(void) layoutSubviews
{	
	NSLog(@"layoutSubviews on section: %d", index);

    CGRect visibleBounds = [self bounds];
	
	[self.subview size:self.cellSize bounds:visibleBounds];	
}

-(void) scrollViewDidScroll:(UIScrollView *)scrollView
{
	NSLog(@"scrollViewDidScroll on section: %d", ((TheBoxUISectionView *)scrollView).index);
    CGRect visibleBounds = [self bounds];
	
	[self.subview size:self.cellSize bounds:visibleBounds];	
}

-(UIView *)dequeueReusableCell {	
return [self.subview dequeueReusableView];
}

-(void)didRecycle:(TheBoxUIRecycleStrategy *)recycleStrategy
{	
	[self.subview didRecycle:recycleStrategy];
}

-(UIView *)shouldBeVisible:(int)column
{
	NSLog(@"column: %d shouldBeVisible on section: %d", column, self.index);
	
	UIView *view = [self viewForColumn:column inSection:self.index];
	[self.subview addSubview:view];
return view;
}

/*
 */
-(CGRect) cellFrame:(NSUInteger) column{
return CGRectMake(CELL_FRAME_WIDTH * column, CELL_FRAME_Y, CELL_FRAME_WIDTH, CELL_FRAME_HEIGHT);
}

-(NSInteger)numberOfColumns{
return [self.datasource numberOfColumnsInSection:self.index];	
}

-(UIView *)viewForColumn:(NSUInteger)column inSection:(NSUInteger) section
{
	NSLog(@"asking for column %d at section %d", column, section);

	UIView *cell = [self dequeueReusableCell];
	
    if (cell == nil) 
	{
        NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"TheBoxUICell" owner:self options:nil];
		cell = [views objectAtIndex:0];
	}
	
	cell.frame = [self cellFrame:column];
	
return [self.datasource columnView:cell forColumn:column inSection:section];
}

@end
