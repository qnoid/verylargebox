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
#import <UIKit/UIKit.h>
#import "TheBoxUICellVisibleStrategy.h"
#import "VisibleStrategy.h"
#import "UIViews.h"

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
	
	UIViews *foo = [[UIViews alloc] init];
	self.views = [foo of:[NSArray arrayWithObjects:first, second, third, forth, fifth, nil]];
	[foo release];
}


-(UIView *)shouldBeVisible:(int)index {
return [self.views objectAtIndex:index];
}

-(void)testWillAppear
{
	CGSize cellSize = CGSizeMake(160, 198);
	CGRect visibleBounds = CGRectMake(0, 0, 320, 198);
	
	TheBoxUICellVisibleStrategy *visibleStrategy = 
		[[[TheBoxUICellVisibleStrategy alloc] init] autorelease];
	
	visibleStrategy.delegate = self;	
	[visibleStrategy willAppear:cellSize within:visibleBounds];	

	STAssertTrue(2 == visibleStrategy.visibleViews.count, [NSString stringWithFormat:@"actual: %d", visibleStrategy.visibleViews.count]);
	
	for (int visibleCell = visibleStrategy.currentMinimumVisibleCell; visibleCell < visibleStrategy.currentMaximumVisibleCell; visibleCell++) {
		STAssertTrue([visibleStrategy.visibleViews containsObject:[self.views objectAtIndex:visibleCell]], nil);
	}
	
	STAssertTrue(0 == visibleStrategy.currentMinimumVisibleCell, [NSString stringWithFormat:@"actual: %d", visibleStrategy.currentMinimumVisibleCell]);
	STAssertTrue(1 == visibleStrategy.currentMaximumVisibleCell, [NSString stringWithFormat:@"actual: %d", visibleStrategy.currentMaximumVisibleCell]);
}

-(void)assertWillAppear:(CGSize) cellSize visibleBounds:(CGRect)visibleBounds howMany:(NSUInteger)howMany minimum:(NSUInteger)minimum maximum:(NSUInteger)maximum
{
	TheBoxUICellVisibleStrategy *visibleStrategy = 
	[[[TheBoxUICellVisibleStrategy alloc] init] autorelease];
	
	visibleStrategy.delegate = self;	
	[visibleStrategy willAppear:cellSize within:visibleBounds];	
	
	STAssertTrue(howMany == visibleStrategy.visibleViews.count, [NSString stringWithFormat:@"actual: %d", visibleStrategy.visibleViews.count]);
	
	for (int visibleCell = visibleStrategy.currentMinimumVisibleCell; visibleCell < visibleStrategy.currentMaximumVisibleCell; visibleCell++) {
		STAssertTrue([visibleStrategy.visibleViews containsObject:[self.views objectAtIndex:visibleCell]], nil);
	}
	
	STAssertTrue(minimum == visibleStrategy.currentMinimumVisibleCell, [NSString stringWithFormat:@"actual: %d", visibleStrategy.currentMinimumVisibleCell]);
	STAssertTrue(maximum == visibleStrategy.currentMaximumVisibleCell, [NSString stringWithFormat:@"actual: %d", visibleStrategy.currentMaximumVisibleCell]);	
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
	TheBoxUICellVisibleStrategy *visibleStrategy = 
		[[[TheBoxUICellVisibleStrategy alloc] init] autorelease];

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
