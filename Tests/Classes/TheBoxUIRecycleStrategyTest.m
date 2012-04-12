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
#import "UITestViews.h"

@interface TheBoxUIRecycleStrategyTest : SenTestCase {
	
}

@end

@implementation TheBoxUIRecycleStrategyTest

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
-(TheBoxUIRecycleStrategy *)recycleViewsBounds:(CGRect) frame visibleBounds:(CGRect) visibleBounds;
{
	UIView *view = [[UIView alloc] initWithFrame:frame];
	NSArray *views = [NSArray arrayWithObject:view];
	
	TheBoxUIRecycleStrategy *recycleStrategy = [TheBoxUIRecycleStrategy newPartiallyVisibleWithinY];
	
	[recycleStrategy recycle:views bounds:visibleBounds];
	
return recycleStrategy;
}


/*
 *
 */ 
-(void)testRecycle:(TheBoxUIRecycleStrategy *)recycleStrategy visibleBounds:(CGRect)visibleBounds views:(NSArray *) views scrollVerticalBy:(NSUInteger)height
{
	[recycleStrategy recycle:views bounds:visibleBounds];	
	[self assertNotRecycled:recycleStrategy];		
	
	visibleBounds = [self scrollVertical:visibleBounds by:1];
	[recycleStrategy recycle:views bounds:visibleBounds];	
	[self assertNotRecycled:recycleStrategy];
	
	int noOfViews = views.count;
	for (int recycledViews = 1; recycledViews < noOfViews; recycledViews++) 
	{
		visibleBounds = [self scrollVertical:visibleBounds by:height];
		[recycleStrategy recycle:views bounds:visibleBounds];	
		[self assertRecycled:recycleStrategy count:recycledViews];
	}
	
	visibleBounds = [self scrollVertical:visibleBounds by:height];
	[recycleStrategy recycle:views bounds:visibleBounds];	
	[self assertRecycled:recycleStrategy count:noOfViews];
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
	
    NSArray* frames = [NSArray arrayWithObjects:first, second, third, forth, nil];
    
	NSArray *views = [[[UITestViews alloc] init]of:frames];
	
	TheBoxUIRecycleStrategy *recycleStrategy = [TheBoxUIRecycleStrategy newPartiallyVisibleWithinY];
	
	CGRect visibleBounds = CGRectMake(0, 0, 320, 392);
	
	[self testRecycle:recycleStrategy visibleBounds:visibleBounds views:views scrollVerticalBy:196];
}

-(void)testGivenViewIsRecycledAssertIsRemovedFromSuperview
{
    UIView *superView = [[UIView alloc] initWithFrame:CGRectMake(0, 196, 320, 196)];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 196)];
    [superView addSubview:view];
    	
	TheBoxUIRecycleStrategy *recycleStrategy = [TheBoxUIRecycleStrategy newPartiallyVisibleWithinY];	
	CGRect visibleBounds = CGRectMake(0, 197, 320, 392);
	
    [recycleStrategy recycle:[NSArray arrayWithObject:view] bounds:visibleBounds];
    
    NSLog(@"%@", [view superview]);
    STAssertNil([view superview], nil);
}

-(void)testRecycleViewsBoundsForSingleView
{
	CGRect view = CGRectMake(0, 0, 320, 196);
	CGRect visibleBounds = CGRectMake(0, 0, 320, 196);
	
	TheBoxUIRecycleStrategy *recycleStrategy = [self recycleViewsBounds:view visibleBounds:visibleBounds];	
	[self assertNotRecycled:recycleStrategy];
	
	visibleBounds = [self scrollVertical:visibleBounds by:196];
	recycleStrategy = [self recycleViewsBounds:view visibleBounds:visibleBounds];
	[self assertRecycled:recycleStrategy count:1];		
	
	visibleBounds = [self scrollVertical:visibleBounds by:-1];
	
	recycleStrategy = [self recycleViewsBounds:view visibleBounds:visibleBounds];
	[self assertNotRecycled:recycleStrategy];		
	
	visibleBounds = [self scrollVertical:visibleBounds by:1];
	
	recycleStrategy = [self recycleViewsBounds:view visibleBounds:visibleBounds];
	[self assertRecycled:recycleStrategy count:1];		    
}


-(void)testDequeueReusableSection
{
	CGRect frame = CGRectMake(0, 0, 320, 196);
	UIView *cell = [[UIView alloc] initWithFrame:frame];
	NSArray *views = [NSArray arrayWithObjects:cell, nil];
	
	TheBoxUIRecycleStrategy *cellRecycleStrategy = [TheBoxUIRecycleStrategy newPartiallyVisibleWithinY];
	
	CGRect visibleBounds = CGRectMake(0, 197, 320, 196);
	
	[cellRecycleStrategy recycle:views bounds:visibleBounds];
	
	STAssertNotNil([cellRecycleStrategy dequeueReusableView], @"view should have been recycled");	
	STAssertNil([cellRecycleStrategy dequeueReusableView], @"there shouldn't be any more recycled views");	
}

-(void)testIsVisible
{
	
}

@end
