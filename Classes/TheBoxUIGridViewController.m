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
#import "TheBoxUIGridView.h"
#import "TheBoxUICell.h"
#import "TheBoxUISectionView.h"
#import "TheBox.h"
#import "TheBoxRect.h"
#import "TheBoxVisibleStrategy.h"

@interface TheBoxUIGridViewController ()
@property(nonatomic, retain) TheBoxUIGridView *gridView;

@property(nonatomic, retain) TheBoxRect *sectionRect;

@end

static const int GRID_FRAME_X = 0;
static const int GRID_FRAME_Y = 88;
static const int GRID_FRAME_WIDTH = 320;
static const int GRID_FRAME_HEIGHT = 392;

static const int SECTION_FRAME_X = 0;
static const int SECTION_FRAME_Y = 0;
static const int SECTION_FRAME_WIDTH = 320;
static const int SECTION_FRAME_HEIGHT = 196;

static const int COLUMN_FRAME_WIDTH = 160;

static const int CELL_FRAME_Y = 0;

static const int CELL_FRAME_WIDTH = 160;
static const int CELL_FRAME_HEIGHT = 196;



@implementation TheBoxUIGridViewController

TheBoxUIGridView *gridView;

TheBoxRect *sectionRect;


@synthesize gridView;

@synthesize sectionRect;

- (void) dealloc
{
	[self.gridView release];
	
	[self.sectionRect release];
	[super dealloc];
}

/*
 * Creates the grid view
 * Add the grid view as a subview
 */
-(void) viewDidLoad
{
	self.sectionRect = [[TheBoxRect alloc] initWithFrame:CGRectMake(SECTION_FRAME_X, SECTION_FRAME_Y, SECTION_FRAME_WIDTH, SECTION_FRAME_HEIGHT)];

	TheBoxUIGridView *theGridView = [TheBoxUIGridView 
					 newGridView:CGRectMake(GRID_FRAME_X, GRID_FRAME_Y, GRID_FRAME_WIDTH, GRID_FRAME_HEIGHT) 
					 datasource:self
					 delegate:self];		
	
	theGridView.clipsToBounds = YES;
			
	self.gridView = theGridView;
	[self.view addSubview:theGridView];
	[theGridView release];
}

-(UIView *)gridView:(TheBoxUIGridView *)theGridView sectionForIndex:(NSInteger)index
{
	NSLog(@"asking for section %d", index);
	
	TheBoxUISectionView *view = (TheBoxUISectionView *)[theGridView dequeueReusableSection];
	
	NSUInteger noOfColumns = [self numberOfColumnsInSection:index];
	
	CGRect frame = [self.sectionRect frame:index minimumWidth:noOfColumns * COLUMN_FRAME_WIDTH];
	
    if (view == nil) {
		view = [[[TheBoxUISectionView alloc] initWithFrame:frame] autorelease];
		view.clipsToBounds = YES;
		view.datasource = self;		
	}
	
	view.index = index;
	view.frame = frame;
	[view setNeedsLayout];

	NSLog(@"view %@", view);
	
return view;	
}

/*
 */
-(CGRect) cellFrame:(NSUInteger) column{
return CGRectMake(CELL_FRAME_WIDTH * column, CELL_FRAME_Y, CELL_FRAME_WIDTH, CELL_FRAME_HEIGHT);
}

-(UIView *)sectionView:(TheBoxUISectionView *)sectionView cellForIndex:(NSInteger)index
{
	NSLog(@"asking for column %d at section %d", index, sectionView.index);
	
	TheBoxUICell *cell = (TheBoxUICell*)[sectionView dequeueReusableCell];
	
	CGRect frame = [self cellFrame:index];

    if (cell == nil) 
	{
        NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"TheBoxUICell" owner:self options:nil];
		cell = [views objectAtIndex:0];
	}
	
	cell.frame = frame;
	NSLog(@"cell %@", cell);

return cell;
}

-(void)setNeedsLayout
{
	[self.gridView setNeedsLayout];
}

- (CGFloat)whatRowHeight:(TheBoxUIGridView *)gridView{
return SECTION_FRAME_HEIGHT;
}

-(UIView *)gridView:(TheBoxUIGridView *)gridView section:(UIView *)section forSection:(NSInteger)index{
return section;
}

-(UIView *)gridView:(TheBoxUIGridView *)gridView forColumn:(UIView *)column withIndex:(NSInteger)index{
return column;
}

-(NSInteger)numberOfSectionsInGridView:(TheBoxUIGridView *)theGridView{
return 0;
}

-(NSUInteger)numberOfColumnsInSection:(NSUInteger)index{
return 0;
}
@end
