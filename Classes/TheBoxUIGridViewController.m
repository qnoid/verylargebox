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
#import "TheBoxUISectionViewBuilder.h"

@interface TheBoxUIGridViewController ()

@end

static const int GRID_FRAME_X = 0;
static const int GRID_FRAME_Y = 88;
static const int GRID_FRAME_WIDTH = 320;
static const int GRID_FRAME_HEIGHT = 392;

static const int SECTION_FRAME_HEIGHT = 196;


@implementation TheBoxUIGridViewController

/*
 * Creates the grid view
 * Add the grid view as a subview
 */
- (void)viewDidLoad
{	
	TheBoxUIGridView *gridView = [TheBoxUIGridView 
					 newGridView:CGRectMake(GRID_FRAME_X, GRID_FRAME_Y, GRID_FRAME_WIDTH, GRID_FRAME_HEIGHT) 
					 datasource:self];		
	gridView.sectionBuilder = [[TheBoxUISectionViewBuilder alloc] initWithDatasource:self];
		
	[self.view addSubview:gridView];
	[gridView release];
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
