/*
 *  Copyright 2010 The Box
 *  All rights reserved.
 *
 *  This file is part of TheBox
 *
 *  Created by Markos Charatzas <[firstname.lastname@gmail.com]> on 27/11/10.
 *  Contributor(s): .-
 */
#import "TheBoxUICellVisibleStrategy.h"
#import "TheBoxSize.h"

@implementation TheBoxUICellVisibleStrategy

@synthesize delegate;
@synthesize visibleViews;
@synthesize currentMinimumVisibleCell;
@synthesize currentMaximumVisibleCell;

- (void) dealloc
{
	[self.visibleViews release];
	[super dealloc];
}


- (id)init
{
	self = [super init];
	
	if (self) 
	{
		self.visibleViews = [[NSMutableSet alloc] init];
		self.currentMinimumVisibleCell = NSIntegerMax;
        self.currentMaximumVisibleCell = NSIntegerMin;
	}
	
return self;
}

-(BOOL)isVisible:(NSInteger) index 
{
	BOOL isVisible = (self.currentMinimumVisibleCell <= index) && (index <= self.currentMaximumVisibleCell);
	
	NSLog(@"is cell: %d visible {%d <= %d <= %d}? %@", index, currentMinimumVisibleCell, index, currentMaximumVisibleCell, (isVisible ? @"YES" : @"NO"));
return isVisible;
}

- (void)willAppear:(CGSize)size within:(CGRect) bounds
{
	NSLog(@"willAppear on bounds %@", NSStringFromCGRect(bounds));
	
	TheBoxSize *theCellFrame = [[TheBoxSize alloc] initWithSize:size];
	
	NSUInteger minimumVisibleCell = [theCellFrame minimumVisible:bounds];
	NSUInteger maximumVisibleCell = [theCellFrame maximumVisible:bounds];
	
	NSLog(@"%d => visible cells < %d", minimumVisibleCell, maximumVisibleCell);
	
	for (int currentCell = minimumVisibleCell; currentCell < maximumVisibleCell; currentCell++) 
	{
		if(![self isVisible:currentCell]){
			NSLog(@"cell %d isn't currently visible {%d <= %d <= %d}", currentCell, currentMinimumVisibleCell, currentCell, currentMaximumVisibleCell);
			UIView *view = [self.delegate shouldBeVisible:currentCell];
			[self.visibleViews addObject:view];
		}
	}
	
	[theCellFrame release];
	
	self.currentMinimumVisibleCell = minimumVisibleCell;
	self.currentMaximumVisibleCell = maximumVisibleCell - 1;	
}

-(void) reset
{
	self.currentMinimumVisibleCell = NSIntegerMax;
	self.currentMaximumVisibleCell = NSIntegerMin;
}


@end
