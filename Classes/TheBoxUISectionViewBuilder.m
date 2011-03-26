/*
 *  Copyright 2010 The Box
 *  All rights reserved.
 *
 *  This file is part of TheBox
 *
 *  Created by Markos Charatzas <[firstname.lastname@gmail.com]> on 28/11/10.
 *  Contributor(s): .-
 */
#import "TheBoxUISectionViewBuilder.h"
#import "TheBoxUISectionView.h"
#import "TheBoxUISectionViewConfiguration.h"

@interface TheBoxUISectionViewBuilder ()
-(CGRect) frame:(NSUInteger)section noOfColumns:(NSUInteger) columns;
@end

@implementation TheBoxUISectionViewBuilder

static const int SECTION_FRAME_X = 0;
static const int SECTION_FRAME_WIDTH = 320;
static const int SECTION_FRAME_HEIGHT = 196;
static const int COLUMN_FRAME_WIDTH = 160;


@synthesize datasource;

-(id) initWithDatasource:(id <TheBoxUISectionViewDatasource>) aDatasource
{
	self = [super init];
	
	if (self) {
		self.datasource = aDatasource;
	}
	
return self;
}

-(CGRect) frame:(NSUInteger)section noOfColumns:(NSUInteger) columns {
return CGRectMake(SECTION_FRAME_X, SECTION_FRAME_HEIGHT * section, MIN(columns * COLUMN_FRAME_WIDTH, SECTION_FRAME_WIDTH), SECTION_FRAME_HEIGHT);	
}

-(NSUInteger)numberOfColumnsInSection:(NSUInteger)section{
return [datasource numberOfColumnsInSection:section];
}

-(TheBoxUISectionView *) newSection:(NSUInteger) section
{
	NSUInteger columns = [self numberOfColumnsInSection:section];
	CGRect frame = [self frame:section noOfColumns:columns];
	NSLog(@"building section: %d with frame: %@", section, NSStringFromCGRect(frame) );
	TheBoxUISectionView *view = [[TheBoxUISectionView alloc] initWithFrame:frame];
	view.index = section;
	view.datasource = self.datasource;	
	
return view;
}

@end
