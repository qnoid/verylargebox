/*
 *  Copyright 2010 TheBox
 *  All rights reserved.
 *
 *  This file is part of TheBox
 *
 *  Created by Markos Charatzas <[firstname.lastname@gmail.com]> on 04/04/2011.
 *  Contributor(s): .-
 */
#import <SenTestingKit/SenTestingKit.h>
#import "TheBoxSize.h"

@interface TheBoxSizeTest : SenTestCase
{
}

@end


@implementation TheBoxSizeTest

- (void) testContentSizeOfRowsZero
{
	CGSize size = CGSizeMake(320, 392);
	TheBoxSize *theBoxSize = [[TheBoxSize alloc] initWithSize:size];
	
	CGSize actual = [theBoxSize sizeOf:0 height:196];
	
	STAssertEquals(actual, CGSizeMake(320, 0), @"actual: %@ expected: %@", NSStringFromCGSize(actual), NSStringFromCGSize(CGSizeMake(320, 0)));
	
}

- (void) testContentSizeOfRowsOne
{
	CGSize size = CGSizeMake(320, 392);
	TheBoxSize *theBoxSize = [[TheBoxSize alloc] initWithSize:size];
	
	CGSize actual = [theBoxSize sizeOf:1 height:196];
	
	STAssertEquals(actual, CGSizeMake(320, 196), @"actual: %@ expected: %@", NSStringFromCGSize(actual), NSStringFromCGSize(CGSizeMake(320, 196)));
	
}

- (void) testContentSizeOfRowsTwo
{
	CGSize size = CGSizeMake(320, 196);
	TheBoxSize *theBoxSize = [[TheBoxSize alloc] initWithSize:size];
	
	CGSize actual = [theBoxSize sizeOf:2 height:196];
	
	STAssertEquals(actual, CGSizeMake(320, 196 * 2), nil);
	
}

- (void) testContentSizeOfRowsOdd
{
	CGSize size = CGSizeMake(320, 392);
	TheBoxSize *theBoxSize = [[TheBoxSize alloc] initWithSize:size];
	
	CGSize actual = [theBoxSize sizeOf:3 height:196];
	
	STAssertEquals(actual, CGSizeMake(320, 196 * 3), nil);
	
}


- (void) testContentSizeOfRowsEven
{
	CGSize size = CGSizeMake(320, 392);
	TheBoxSize *theBoxSize = [[TheBoxSize alloc] initWithSize:size];
	
	CGSize actual = [theBoxSize sizeOf:4 height:196];
	
	STAssertEquals(actual, CGSizeMake(320, 196 * 4), nil);
	
}

- (void) testContentSizeOfColumnsZero
{
	CGSize size = CGSizeMake(320, 392);
	TheBoxSize *theBoxSize = [[TheBoxSize alloc] initWithSize:size];
	
	CGSize actual = [theBoxSize sizeOf:0 width:160];
	
	STAssertEquals(actual, CGSizeMake(0, 392), @"actual: %@ expected: %@", NSStringFromCGSize(actual), NSStringFromCGSize(CGSizeMake(320, 0)));
	
}

- (void) testContentSizeOfColumnsOne
{
	CGSize size = CGSizeMake(320, 392);
	TheBoxSize *theBoxSize = [[TheBoxSize alloc] initWithSize:size];
	
	CGSize actual = [theBoxSize sizeOf:1 width:160];
	
	STAssertEquals(actual, CGSizeMake(160, 392), @"actual: %@ expected: %@", NSStringFromCGSize(actual), NSStringFromCGSize(CGSizeMake(320, 196)));
	
}

- (void) testContentSizeOfColumnsTwo
{
	CGSize size = CGSizeMake(320, 392);
	TheBoxSize *theBoxSize = [[TheBoxSize alloc] initWithSize:size];
	
	CGSize actual = [theBoxSize sizeOf:2 width:160];
	
	STAssertEquals(actual, CGSizeMake(160*2, 392), nil);
	
}

- (void) testContentSizeOfColumnsdd
{
	CGSize size = CGSizeMake(320, 392);
	TheBoxSize *theBoxSize = [[TheBoxSize alloc] initWithSize:size];
	
	CGSize actual = [theBoxSize sizeOf:3 width:160];
	
	STAssertEquals(actual, CGSizeMake(160*3, 392), nil);
	
}


- (void) testContentSizeOfColumnsEven
{
	CGSize size = CGSizeMake(320, 392);
	TheBoxSize *theBoxSize = [[TheBoxSize alloc] initWithSize:size];
	
	CGSize actual = [theBoxSize sizeOf:4 width:160];
	
	STAssertEquals(actual, CGSizeMake(160*4, 392), nil);
	
}


@end
