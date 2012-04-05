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
#import "TheBoxVisibleStrategy.h"
#import "VisibleStrategy.h"
#import "UITestViews.h"

@interface TheBoxUICellVisibleStrategyTest : SenTestCase <VisibleStrategyDelegate> 
{
	@private
		NSArray *views;
	
}

@property(nonatomic, retain) NSArray *views;

@end

@implementation TheBoxUICellVisibleStrategyTest

@synthesize views;

-(void)setUp
{
	NSValue *first = [NSValue valueWithCGRect:CGRectMake(0, 0, 160, 196)];
	NSValue *second = [NSValue valueWithCGRect:CGRectMake(160, 0, 160, 196)];
	NSValue *third = [NSValue valueWithCGRect:CGRectMake(320, 0, 160, 196)];
	NSValue *forth = [NSValue valueWithCGRect:CGRectMake(480, 0, 160, 196)];
	NSValue *fifth = [NSValue valueWithCGRect:CGRectMake(640, 0, 160, 196)];
	
	UITestViews *foo = [[UITestViews alloc] init];
	self.views = [foo of:[NSArray arrayWithObjects:first, second, third, forth, fifth, nil]];
	[foo release];
}


-(UIView *)shouldBeVisible:(int)index {
return [self.views objectAtIndex:index];
}

-(void)testWillAppear
{
	CGRect visibleBounds = CGRectMake(0, 0, 320, 198);
	
	NSObject<TheBoxDimension> *dimension = [[TheBoxSize newHeight:160] autorelease];
	
	TheBoxVisibleStrategy *visibleStrategy = 
		[[TheBoxVisibleStrategy newVisibleStrategyOn:dimension] autorelease];
	
	visibleStrategy.delegate = self;	
	[visibleStrategy willAppear:visibleBounds];	

	STAssertTrue(2 == visibleStrategy.visibleViews.count, @"actual: %d", visibleStrategy.visibleViews.count);
	
	for (int visibleCell = visibleStrategy.minimumVisibleIndex; visibleCell < visibleStrategy.maximumVisibleIndex; visibleCell++) {
		STAssertTrue([visibleStrategy.visibleViews containsObject:[self.views objectAtIndex:visibleCell]], nil);
	}
	
	STAssertTrue(0 == visibleStrategy.minimumVisibleIndex, @"actual: %d", visibleStrategy.minimumVisibleIndex);
	STAssertTrue(1 == visibleStrategy.maximumVisibleIndex, @"actual: %d", visibleStrategy.maximumVisibleIndex);
}

-(void)assertWillAppear:(CGSize) cellSize visibleBounds:(CGRect)visibleBounds howMany:(NSUInteger)howMany minimum:(NSUInteger)minimum maximum:(NSUInteger)maximum
{
	NSObject<TheBoxDimension> *dimension = [[TheBoxSize newWidth:cellSize.width] autorelease];

	TheBoxVisibleStrategy *visibleStrategy = 
	[[TheBoxVisibleStrategy newVisibleStrategyOn:dimension] autorelease];
	
	visibleStrategy.delegate = self;	
	[visibleStrategy willAppear:visibleBounds];	
	
	STAssertTrue(howMany == visibleStrategy.visibleViews.count, @"expected: %d actual: %d", howMany, visibleStrategy.visibleViews.count);
	
	for (int visibleCell = visibleStrategy.minimumVisibleIndex; visibleCell < visibleStrategy.maximumVisibleIndex; visibleCell++) {
		STAssertTrue([visibleStrategy.visibleViews containsObject:[self.views objectAtIndex:visibleCell]], nil);
	}
	
	STAssertTrue(minimum == visibleStrategy.minimumVisibleIndex, @"expected: %d actual: %d", minimum, visibleStrategy.minimumVisibleIndex);
	STAssertTrue(maximum == visibleStrategy.maximumVisibleIndex, @"expected: %d actual: %d", maximum, visibleStrategy.maximumVisibleIndex);	
}

-(void)testWillAppearSingle
{
	CGSize cellSize = CGSizeMake(160, 198);
	CGRect visibleBounds = CGRectMake(0, 0, 160, 198);
	[self assertWillAppear:cellSize visibleBounds:visibleBounds howMany:1 minimum:0 maximum:0];

	visibleBounds = CGRectMake(0, 0, 320, 198);	
	[self assertWillAppear:cellSize visibleBounds:visibleBounds howMany:2 minimum:0 maximum:1];
	
	visibleBounds = CGRectMake(1, 0, 320, 198);
	[self assertWillAppear:cellSize visibleBounds:visibleBounds howMany:3 minimum:0 maximum:2];

	 visibleBounds = CGRectMake(80, 0, 320, 198);
	[self assertWillAppear:cellSize visibleBounds:visibleBounds howMany:3 minimum:0 maximum:2];

	 visibleBounds = CGRectMake(160, 0, 320, 198);
	[self assertWillAppear:cellSize visibleBounds:visibleBounds howMany:2 minimum:1 maximum:2];
	
	 visibleBounds = CGRectMake(200, 0, 320, 198);
	[self assertWillAppear:cellSize visibleBounds:visibleBounds howMany:3 minimum:1 maximum:3];
	
	 visibleBounds = CGRectMake(360, 0, 320, 198);
	[self assertWillAppear:cellSize visibleBounds:visibleBounds howMany:3 minimum:2 maximum:4];
	
	 visibleBounds = CGRectMake(480, 0, 320, 198);
	[self assertWillAppear:cellSize visibleBounds:visibleBounds howMany:2 minimum:3 maximum:4];		
}

-(void)testIsVisible
{
	NSObject<TheBoxDimension> *dimension = [[TheBoxSize newWidth:0] autorelease];

	TheBoxVisibleStrategy *visibleStrategy = 
		[[TheBoxVisibleStrategy newVisibleStrategyOn:dimension] autorelease];

	NSInteger zero = 0;
	NSInteger one = 1;
	
	BOOL greaterThanMinimum = NSIntegerMax <= zero;
	BOOL lessThanMaximum = zero <= NSIntegerMin;
	
	STAssertFalse(greaterThanMinimum, nil);
	STAssertFalse(lessThanMaximum, nil);	
	STAssertFalse(greaterThanMinimum || lessThanMaximum, nil);	
	STAssertFalse([visibleStrategy isVisible:zero], nil);
	STAssertFalse([visibleStrategy isVisible:one], nil);
}
				 
				 
@end
