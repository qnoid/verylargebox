/*
 *  Copyright 2010 The Box
 *  All rights reserved.
 *
 *  This file is part of TheBox
 *
 *  Created by Markos Charatzas <[firstname.lastname@gmail.com]> on 23/11/10.
 *  Contributor(s): .-
 */
#import "TheBoxUIGridViewController.h"
#import "TheBoxUIScrollView.h"
#import "TheBoxUICell.h"
#import "TheBox.h"
#import "TheBoxRect.h"
#import "TheBoxVisibleStrategy.h"
#import "TheBoxUIRecycleStrategy.h"
#import "TheBoxUIGridViewDelegate.h"

#import <QuartzCore/QuartzCore.h>

@interface TheBoxUIGridViewController ()
@property(nonatomic, retain) TheBoxRect *viewRect;
@property(nonatomic, retain) TheBoxRect *cellRect;
@property(nonatomic, retain) TheBoxUIGridViewDelegate *gridViewDelegate;
@end

static const int GRID_FRAME_X = 0;
static const int GRID_FRAME_Y = 44;
static const int GRID_FRAME_WIDTH = 320;
static const int GRID_FRAME_HEIGHT = 392 + 44;

static const int SECTION_FRAME_X = 0;
static const int SECTION_FRAME_Y = 0;
static const int SECTION_FRAME_WIDTH = 320;
static const int SECTION_FRAME_HEIGHT = 196;

static const int CELL_FRAME_X = 0;
static const int CELL_FRAME_Y = 0;
static const int CELL_FRAME_WIDTH = 160;
static const int CELL_FRAME_HEIGHT = 196;


@implementation TheBoxUIGridViewController

#pragma mark private fields
TheBoxRect *viewRect;
TheBoxRect *cellRect;
TheBoxUIGridViewDelegate *gridViewDelegate;

@synthesize gridView;
@synthesize viewRect;
@synthesize cellRect;
@synthesize gridViewDelegate;

- (void) dealloc
{
	[gridView release];
	[viewRect release];
	[cellRect release];
	[gridViewDelegate release];
	[super dealloc];
}

/*
 * Creates the grid view
 * Add the grid view as a subview
 */
-(void) viewDidLoad
{
    TheBoxRect* rowRect = [[TheBoxRect alloc] initWithFrame:
     CGRectMake(SECTION_FRAME_X, SECTION_FRAME_Y, SECTION_FRAME_WIDTH, SECTION_FRAME_HEIGHT)];
    
	self.viewRect = rowRect;
	
    
    TheBoxRect* columnRect = [[TheBoxRect alloc] initWithFrame:
                              CGRectMake(CELL_FRAME_X, CELL_FRAME_Y, CELL_FRAME_WIDTH, CELL_FRAME_HEIGHT)];
    
	self.cellRect = columnRect;	
	
    TheBoxUIGridViewDelegate* theGridViewDelegate = 
        [[TheBoxUIGridViewDelegate alloc] init];
    
	self.gridViewDelegate = theGridViewDelegate;
	self.gridViewDelegate.datasource = self;
		
	TheBoxUIScrollView *aGridView = 
		[TheBoxUIScrollView 
			newVerticalScrollView:CGRectMake(GRID_FRAME_X, GRID_FRAME_Y, GRID_FRAME_WIDTH, GRID_FRAME_HEIGHT)
			viewsOf:SECTION_FRAME_HEIGHT];

	aGridView.scrollViewDelegate = self;
	aGridView.datasource = self;	
	aGridView.clipsToBounds = YES;
	
	self.gridView = aGridView;
	[self.view addSubview:self.gridView];			
	
	[aGridView release];
    [theGridViewDelegate release];
    [columnRect release];
    [rowRect release];
}

-(void)reloadData
{
    id<TheBoxDimension> dimension = [TheBoxSize newHeight:SECTION_FRAME_HEIGHT];        
	[self.gridView setNeedsLayout:dimension];
    [dimension release];
}

-(CGSize)contentSizeOf:(TheBoxUIScrollView *)scrollView withData:(id<TheBoxUIScrollViewDatasource>)datasource
{
	NSUInteger numberOfViews = [datasource numberOfViews:scrollView];
	CGFloat height = [self whatRowHeight:scrollView];
	
return [scrollView.theBoxSize sizeOf:numberOfViews height:height];
}

- (CGFloat)whatRowHeight:(TheBoxUIScrollView *)gridView{
return SECTION_FRAME_HEIGHT;
}

-(UIView *)viewOf:(TheBoxUIScrollView *)scrollView atRow:(NSInteger)row atIndex:(NSInteger)index
{
	NSLog(@"asking for column %d at row %d", index, row);
	
	UIView* view = [scrollView dequeueReusableView];
	
	CGRect frame = [self frameOf:scrollView atRow:row atIndex:index];

    if (view == nil) 
	{
        NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"TheBoxUICell" owner:self options:nil];
		view = [views objectAtIndex:0];
	}
	
    view.frame = frame; 
    
    
    [view setNeedsLayout];
    
	NSLog(@"view %@", view);

return view;
}

-(UIView*)viewOf:(TheBoxUIScrollView *)scrollView atIndex:(NSInteger)index
{
	NSLog(@"asking for row %d", index);
	
	UIView* view = [scrollView dequeueReusableView];
	
	NSUInteger noOfColumns = [self numberOfViews:scrollView atIndex:index];
	
	CGRect frame = [self.viewRect frame:index minimumWidth:noOfColumns * CELL_FRAME_WIDTH];
	
    if (view == nil) 
	{		
		TheBoxUIScrollView *viewOf = [[TheBoxUIScrollView 
										newHorizontalScrollView:frame 
										viewsOf:CELL_FRAME_WIDTH]autorelease];
		
		viewOf.clipsToBounds = YES;
		viewOf.datasource = gridViewDelegate;
		viewOf.scrollViewDelegate = gridViewDelegate;
		 
		
		view = viewOf;
	}
    else
    {
        id<TheBoxDimension> dimension = [TheBoxSize newWidth:CELL_FRAME_WIDTH];        
        [(TheBoxUIScrollView*)view setNeedsLayout:dimension];
        [dimension release];
    }

    view.frame = frame; 
    [self.gridViewDelegate setView:view atIndex:index];

	NSLog(@"view %@", view);
	
return view;
}


-(CGRect)frameOf:(TheBoxUIScrollView *)scrollView atRow:(NSInteger)row atIndex:(NSInteger)index
{
    CGRect frame = [self.cellRect frame:index minimumHeight:CELL_FRAME_HEIGHT];
    return frame;    
//    CGSize margins = [self marginOf:scrollView atRow:row atIndex:index];
//    
//return CGRectMake(
//                  frame.origin.x + (margins.width * index), 
//                  frame.origin.y + (margins.height * index), 
//                  frame.size.width, 
//                  frame.size.height);
}

-(NSUInteger)numberOfViews:(TheBoxUIScrollView *)gridView{
return 0;
}

-(NSUInteger)numberOfViews:(TheBoxUIScrollView*)scrollView atIndex:(NSInteger)index{
return 0;
}

-(CGSize)marginOf:(TheBoxUIScrollView*)scrollView atRow:(NSInteger)row atIndex:(NSInteger)index {
return CGSizeMake(0.0, 0.0);
}

@end
