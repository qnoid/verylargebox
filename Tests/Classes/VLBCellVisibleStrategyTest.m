//
//  Copyright 2010 The Box
//  All rights reserved.
//
//  This file is part of TheBox
//
//  Created by Markos Charatzas on 12/12/10.
//
   
#import <XCTest/XCTest.h>
#import "VLBVisibleStrategy.h"
#import "VLBVisibleStrategy.h"
#import "VLBTestViews.h"
#import "VLBScrollView.h"

@interface VLBCellVisibleStrategyTest : XCTestCase <VisibleStrategyDelegate> 
{
	@private
		NSArray *views;
	
}

@property(nonatomic) NSArray *views;

@end

@implementation VLBCellVisibleStrategyTest

@synthesize views;

-(void)setUp
{
	NSValue *first = [NSValue valueWithCGRect:CGRectMake(0, 0, 160, 196)];
	NSValue *second = [NSValue valueWithCGRect:CGRectMake(160, 0, 160, 196)];
	NSValue *third = [NSValue valueWithCGRect:CGRectMake(320, 0, 160, 196)];
	NSValue *forth = [NSValue valueWithCGRect:CGRectMake(480, 0, 160, 196)];
	NSValue *fifth = [NSValue valueWithCGRect:CGRectMake(640, 0, 160, 196)];
	
	VLBTestViews *foo = [[VLBTestViews alloc] init];
	self.views = [foo of:[NSArray arrayWithObjects:first, second, third, forth, fifth, nil]];
}

-(void)viewsShouldBeVisibleBetween:(NSUInteger)minimumVisibleIndex to:(NSUInteger)maximumVisibleIndex{
    
}

-(UIView *)shouldBeVisible:(int)index {
return [self.views objectAtIndex:index];
}

-(void)testWillAppear
{
	CGRect visibleBounds = CGRectMake(0, 0, 320, 198);
	
	NSObject<VLBDimension> *dimension = [VLBHeight newHeight:160];
	
	VLBVisibleStrategy *visibleStrategy =
		[VLBVisibleStrategy newVisibleStrategyOn:dimension];
	
	visibleStrategy.delegate = self;	
	[visibleStrategy layoutSubviews:visibleBounds];	

	XCTAssertTrue(2 == visibleStrategy.visibleViews.count, @"actual: %d", visibleStrategy.visibleViews.count);
	
	for (int visibleCell = visibleStrategy.minimumVisibleIndex; visibleCell < visibleStrategy.maximumVisibleIndex; visibleCell++) {
		XCTAssertTrue([visibleStrategy.visibleViews containsObject:[self.views objectAtIndex:visibleCell]]);
	}
	
	XCTAssertTrue(0 == visibleStrategy.minimumVisibleIndex, @"actual: %d", visibleStrategy.minimumVisibleIndex);
	XCTAssertTrue(1 == visibleStrategy.maximumVisibleIndex, @"actual: %d", visibleStrategy.maximumVisibleIndex);
}

-(void)assertWillAppear:(CGSize) cellSize visibleBounds:(CGRect)visibleBounds howMany:(NSUInteger)howMany minimum:(NSUInteger)minimum maximum:(NSUInteger)maximum
{
	NSObject<VLBDimension> *dimension = [VLBWidth newWidth:cellSize.width];

	VLBVisibleStrategy *visibleStrategy =
	[VLBVisibleStrategy newVisibleStrategyOn:dimension];
	
	visibleStrategy.delegate = self;	
	[visibleStrategy layoutSubviews:visibleBounds];	
	
	XCTAssertTrue(howMany == visibleStrategy.visibleViews.count, @"expected: %@ actual: %@", @(howMany), @(visibleStrategy.visibleViews.count));
	
	for (NSInteger visibleCell = visibleStrategy.minimumVisibleIndex; visibleCell < visibleStrategy.maximumVisibleIndex; visibleCell++) {
		XCTAssertTrue([visibleStrategy.visibleViews containsObject:[self.views objectAtIndex:visibleCell]]);
	}
	
	XCTAssertTrue(minimum == visibleStrategy.minimumVisibleIndex, @"expected: %@ actual: %@", @(minimum), @(visibleStrategy.minimumVisibleIndex));
	XCTAssertTrue(maximum == visibleStrategy.maximumVisibleIndex, @"expected: %@ actual: %@", @(maximum), @(visibleStrategy.maximumVisibleIndex));
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
	NSObject<VLBDimension> *dimension = [VLBWidth newWidth:0];

	VLBVisibleStrategy *visibleStrategy =
		[VLBVisibleStrategy newVisibleStrategyOn:dimension];

	NSInteger zero = 0;
	NSInteger one = 1;
	
	XCTAssertFalse([visibleStrategy isVisible:zero]);
	XCTAssertFalse([visibleStrategy isVisible:one]);
}
				 				 
@end
