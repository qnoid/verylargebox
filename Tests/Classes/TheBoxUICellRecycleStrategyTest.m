/*
 *  Copyright 2010 The Box
 *  All rights reserved.
 *
 *  This file is part of TheBox
 *
 *  Created by Markos Charatzas <[firstname.lastname@gmail.com]> on 12/12/10.
 *  Contributor(s): .-
 */
#import <SenTestingKit/SenTestingKit.h>
#import "TheBoxUIRecycleStrategy.h"
#import "TheBoxBundle.h"
#import "UITestViews.h"

@interface TheBoxUICellRecycleStrategyTest : SenTestCase {
	
}

@end

@implementation TheBoxUICellRecycleStrategyTest

-(TheBoxUIRecycleStrategy *)recycleViewsBounds:(CGRect) frame visibleBounds:(CGRect) visibleBounds;
{
	UIView *cell = [[UIView alloc] initWithFrame:frame];
	NSArray *views = [NSArray arrayWithObjects:cell, nil];
	[cell release];
	
	TheBoxUIRecycleStrategy *cellRecycleStrategy = [[TheBoxUIRecycleStrategy newPartiallyVisibleWithinX] autorelease];
	
	[cellRecycleStrategy recycle:views bounds:visibleBounds];
	
return cellRecycleStrategy;
}

-(void)assertNotRecycled:(TheBoxUIRecycleStrategy *) cellRecycleStrategy;
{
	STAssertTrue(0 == cellRecycleStrategy.recycledViews.count, @"view is recycled although still visible");
	STAssertNil([cellRecycleStrategy dequeueReusableView], @"view shouldn't have been recycled");	
}

-(void)assertRecycled:(TheBoxUIRecycleStrategy *) recycleStrategy count:(NSUInteger)count;
{
	STAssertTrue(count == recycleStrategy.recycledViews.count, [NSString stringWithFormat:@"actual: %d", recycleStrategy.recycledViews.count]);
	STAssertNotNil([recycleStrategy dequeueReusableView], @"view should have been recycled");
}

-(CGRect)scrollHorizontal:(CGRect)bounds by:(int)diff{
return CGRectMake(bounds.origin.x + diff, bounds.origin.y, bounds.size.width, bounds.size.height);
}

/* 
 *		 160  
 *		-----------
 *	196 |cell|    |
 *		-----------
 *			320
 */

-(void)testRecycleViewsBoundsForSingleCell
{
	CGRect cellFrame = CGRectMake(0, 0, 160, 196);
	CGRect sectionVisibleBounds = CGRectMake(0, 0, 320, 196);
	
	TheBoxUIRecycleStrategy *recycleStrategy = [self recycleViewsBounds:cellFrame visibleBounds:sectionVisibleBounds];	
	[self assertNotRecycled:recycleStrategy];
	
	sectionVisibleBounds = [self scrollHorizontal:sectionVisibleBounds by:160];
	recycleStrategy = [self recycleViewsBounds:cellFrame visibleBounds:sectionVisibleBounds];
	[self assertNotRecycled:recycleStrategy];		
	
	sectionVisibleBounds = [self scrollHorizontal:sectionVisibleBounds by:1];
	
	recycleStrategy = [self recycleViewsBounds:cellFrame visibleBounds:sectionVisibleBounds];
	[self assertRecycled:recycleStrategy count:1];		
	
	sectionVisibleBounds = [self scrollHorizontal:sectionVisibleBounds by:-1];
	
	recycleStrategy = [self recycleViewsBounds:cellFrame visibleBounds:sectionVisibleBounds];
	[self assertNotRecycled:recycleStrategy];		
	
}

/*
 *
 */ 
-(void)testRecycle:(TheBoxUIRecycleStrategy *)recycleStrategy visibleBounds:(CGRect)visibleBounds views:(NSArray *) views scrollHorizontalBy:(NSUInteger)width
{
	[recycleStrategy recycle:views bounds:visibleBounds];	
	[self assertNotRecycled:recycleStrategy];		
	
	visibleBounds = [self scrollHorizontal:visibleBounds by:1];
	[recycleStrategy recycle:views bounds:visibleBounds];	
	[self assertNotRecycled:recycleStrategy];

	int noOfCells = views.count;
	for (int recycledCells = 1; recycledCells < noOfCells; recycledCells++) 
	{
		visibleBounds = [self scrollHorizontal:visibleBounds by:width];
		[recycleStrategy recycle:views bounds:visibleBounds];	
		[self assertRecycled:recycleStrategy count:recycledCells];
	}
	
	visibleBounds = [self scrollHorizontal:visibleBounds by:width];
	[recycleStrategy recycle:views bounds:visibleBounds];	
	[self assertRecycled:recycleStrategy count:noOfCells];
}

/* 
 *		 160  160
 *		-----------
 *	196 |cell|cell|
 *		-----------
 *			320
 */
-(void)testRecycleViewsBoundsForMultipleCells
{
	NSValue *first = [NSValue valueWithCGRect:CGRectMake(0, 0, 160, 196)];
	NSValue *second = [NSValue valueWithCGRect:CGRectMake(160, 0, 160, 196)];
	NSValue *third = [NSValue valueWithCGRect:CGRectMake(320, 0, 160, 196)];
	NSValue *forth = [NSValue valueWithCGRect:CGRectMake(480, 0, 160, 196)];

	NSArray *views = [[[[UITestViews alloc] init] autorelease]of:[NSArray arrayWithObjects:first, second, third, forth, nil]];
	
	TheBoxUIRecycleStrategy *recycleStrategy = [[TheBoxUIRecycleStrategy newPartiallyVisibleWithinX] autorelease];
	
	CGRect visibleBounds = CGRectMake(0, 0, 320, 196);
	
	[self testRecycle:recycleStrategy visibleBounds:visibleBounds views:views scrollHorizontalBy:160];
}

-(void)testDequeueReusableSection
{
	CGRect frame = CGRectMake(0, 0, 160, 196);
	UIView *cell = [[UIView alloc] initWithFrame:frame];
	NSArray *views = [NSArray arrayWithObjects:cell, nil];
	
	TheBoxUIRecycleStrategy *cellRecycleStrategy = [[TheBoxUIRecycleStrategy newPartiallyVisibleWithinX] autorelease];
	
	CGRect visibleBounds = CGRectMake(161, 0, 160, 196);
	
	[cellRecycleStrategy recycle:views bounds:visibleBounds];
	
	STAssertNotNil([cellRecycleStrategy dequeueReusableView], @"view should have been recycled");	
	STAssertNil([cellRecycleStrategy dequeueReusableView], @"there shouldn't be any more recycled views");	
}

@end
