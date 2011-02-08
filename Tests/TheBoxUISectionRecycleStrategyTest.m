/*
 *  Copyright 2010 The Box
 *  All rights reserved.
 *
 *  This file is part of TheBox
 *
 *  Created by Markos Charatzas <[firstname.lastname@gmail.com]> on 15/12/10.
 *  Contributor(s): .-
 */
   
#import <SenTestingKit/SenTestingKit.h>
#import <UIKit/UIKit.h>
#import "TheBoxUIRecycleStrategy.h"
#import "UIViews.h"

@interface TheBoxUISectionRecycleStrategyTest : SenTestCase {
	
}

@end

@implementation TheBoxUISectionRecycleStrategyTest

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

-(CGRect)scrollVertical:(CGRect)bounds by:(int)diff{
return CGRectMake(bounds.origin.x, bounds.origin.y + diff, bounds.size.width, bounds.size.height);
}

/*
 *
 */ 
-(void)testRecycle:(TheBoxUIRecycleStrategy *)recycleStrategy visibleBounds:(CGRect)visibleBounds views:(NSArray *) views scrollVerticalBy:(NSUInteger)height
{
	[recycleStrategy recycle:nil views:views bounds:visibleBounds];	
	[self assertNotRecycled:recycleStrategy];		
	
	visibleBounds = [self scrollVertical:visibleBounds by:1];
	[recycleStrategy recycle:nil views:views bounds:visibleBounds];	
	[self assertNotRecycled:recycleStrategy];
	
	int noOfCells = views.count;
	for (int recycledCells = 1; recycledCells < noOfCells; recycledCells++) 
	{
		visibleBounds = [self scrollVertical:visibleBounds by:height];
		[recycleStrategy recycle:nil views:views bounds:visibleBounds];	
		[self assertRecycled:recycleStrategy count:recycledCells];
	}
	
	visibleBounds = [self scrollVertical:visibleBounds by:height];
	[recycleStrategy recycle:nil views:views bounds:visibleBounds];	
	[self assertRecycled:recycleStrategy count:noOfCells];
}

/* 
 *			320  
 *		---------
 *	196 |section|
 *		---------
 *	196 |section|
 *		---------
 */
-(void)testRecycleViewsBoundsForMultipleSections
{
	NSValue *first = [NSValue valueWithCGRect:CGRectMake(0, 0, 320, 196)];
	NSValue *second = [NSValue valueWithCGRect:CGRectMake(0, 196, 320, 196)];
	NSValue *third = [NSValue valueWithCGRect:CGRectMake(0, 392, 320, 196)];
	NSValue *forth = [NSValue valueWithCGRect:CGRectMake(0, 588, 320, 196)];
	
	NSArray *views = [[[[UIViews alloc] init] autorelease]of:[NSArray arrayWithObjects:first, second, third, forth, nil]];
	
	TheBoxUIRecycleStrategy *recycleStrategy = [[TheBoxUIRecycleStrategy newPartiallyVisibleWithinY] autorelease];
	
	CGRect visibleBounds = CGRectMake(0, 0, 320, 392);
	
	[self testRecycle:recycleStrategy visibleBounds:visibleBounds views:views scrollVerticalBy:196];
}

-(void)testDequeueReusableSection
{
	CGRect frame = CGRectMake(0, 0, 320, 196);
	UIView *cell = [[UIView alloc] initWithFrame:frame];
	NSArray *views = [NSArray arrayWithObjects:cell, nil];
	
	TheBoxUIRecycleStrategy *cellRecycleStrategy = [[TheBoxUIRecycleStrategy newPartiallyVisibleWithinY] autorelease];
	
	CGRect visibleBounds = CGRectMake(0, 197, 320, 196);
	
	[cellRecycleStrategy recycle:nil views:views bounds:visibleBounds];
	
	STAssertNotNil([cellRecycleStrategy dequeueReusableView], @"view should have been recycled");	
	STAssertNil([cellRecycleStrategy dequeueReusableView], @"there shouldn't be any more recycled views");	
}

-(void)testIsVisible
{
	
}

@end
