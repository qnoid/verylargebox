/*
 *  Copyright 2010 The Box
 *  All rights reserved.
 *
 *  This file is part of TheBox
 *
 *  Created by Markos Charatzas (@qnoid) on 12/12/10.
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
	NSArray *views = [NSArray arrayWithObject:cell];
	
	TheBoxUIRecycleStrategy *recycleStrategy = [[TheBoxUIRecycleStrategy alloc] init];
	
	[recycleStrategy recycle:views bounds:visibleBounds];
	
return recycleStrategy;
}

-(void)assertNotRecycled:(TheBoxUIRecycleStrategy *) cellRecycleStrategy;
{
	STAssertTrue(0 == cellRecycleStrategy.recycledViews.count, @"view is recycled although still visible");
	STAssertNil([cellRecycleStrategy dequeueReusableView], @"view has been recycled");	
}

-(void)assertRecycled:(TheBoxUIRecycleStrategy *) recycleStrategy count:(NSUInteger)count;
{
	STAssertTrue(count == recycleStrategy.recycledViews.count, [NSString stringWithFormat:@"expected: %d actual: %d", count, recycleStrategy.recycledViews.count]);    
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
	[self assertRecycled:recycleStrategy count:1];		
	
	sectionVisibleBounds = [self scrollHorizontal:sectionVisibleBounds by:-1];
	
	recycleStrategy = [self recycleViewsBounds:cellFrame visibleBounds:sectionVisibleBounds];
	[self assertNotRecycled:recycleStrategy];		
	
	sectionVisibleBounds = [self scrollHorizontal:sectionVisibleBounds by:1];
	
	recycleStrategy = [self recycleViewsBounds:cellFrame visibleBounds:sectionVisibleBounds];
	[self assertRecycled:recycleStrategy count:1];		    
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

	NSArray *views = [[[UITestViews alloc] init]of:[NSArray arrayWithObjects:first, second, third, forth, nil]];
	
	TheBoxUIRecycleStrategy *recycleStrategy = [[TheBoxUIRecycleStrategy alloc] init];
	
	CGRect visibleBounds = CGRectMake(0, 0, 320, 196);
    CGFloat width = 160;

    [recycleStrategy recycle:views bounds:visibleBounds];
    [self assertRecycled:recycleStrategy count:2];

    visibleBounds = [self scrollHorizontal:visibleBounds by:width];
    [recycleStrategy recycle:views bounds:visibleBounds];	
    [self assertRecycled:recycleStrategy count:3];


    visibleBounds = [self scrollHorizontal:visibleBounds by:width];
    [recycleStrategy recycle:views bounds:visibleBounds];	
    [self assertRecycled:recycleStrategy count:4];
}

-(void)testRecycleViewsBoundsForMultipleCellsInverse
{
	NSValue *first = [NSValue valueWithCGRect:CGRectMake(0, 0, 160, 196)];
	NSValue *second = [NSValue valueWithCGRect:CGRectMake(160, 0, 160, 196)];
	NSValue *third = [NSValue valueWithCGRect:CGRectMake(320, 0, 160, 196)];
	NSValue *forth = [NSValue valueWithCGRect:CGRectMake(480, 0, 160, 196)];
    
	NSArray *views = [[[UITestViews alloc] init]of:[NSArray arrayWithObjects:forth, third, second, first, nil]];
	
	TheBoxUIRecycleStrategy *recycleStrategy = [[TheBoxUIRecycleStrategy alloc] init];
	
	CGRect visibleBounds = CGRectMake(320, 0, 320, 196);
    CGFloat width = -160;
    
    [recycleStrategy recycle:views bounds:visibleBounds];
    [self assertRecycled:recycleStrategy count:2];
    
    visibleBounds = [self scrollHorizontal:visibleBounds by:width];
    [recycleStrategy recycle:views bounds:visibleBounds];	
    [self assertRecycled:recycleStrategy count:3];
    
    
    visibleBounds = [self scrollHorizontal:visibleBounds by:width];
    [recycleStrategy recycle:views bounds:visibleBounds];	
    [self assertRecycled:recycleStrategy count:4];
}


-(void)testDequeueReusableSection
{
	CGRect frame = CGRectMake(0, 0, 160, 196);
	UIView *cell = [[UIView alloc] initWithFrame:frame];
	NSArray *views = [NSArray arrayWithObjects:cell, nil];
	
	TheBoxUIRecycleStrategy *cellRecycleStrategy = [[TheBoxUIRecycleStrategy alloc] init];
	
	CGRect visibleBounds = CGRectMake(161, 0, 160, 196);
	
	[cellRecycleStrategy recycle:views bounds:visibleBounds];
	
	STAssertNotNil([cellRecycleStrategy dequeueReusableView], @"view should have been recycled");	
	STAssertNil([cellRecycleStrategy dequeueReusableView], @"there shouldn't be any more recycled views");	
}

@end
