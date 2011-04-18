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
	
	CGSize actual = [theBoxSize contentSizeOf:196 ofRows:0];
	
	STAssertEquals(actual, CGSizeMake(320, 0), @"actual: %@ expected: %@", NSStringFromCGSize(actual), NSStringFromCGSize(CGSizeMake(320, 0)));
	
	[theBoxSize release];
}

- (void) testContentSizeOfRowsOne
{
	CGSize size = CGSizeMake(320, 392);
	TheBoxSize *theBoxSize = [[TheBoxSize alloc] initWithSize:size];
	
	CGSize actual = [theBoxSize contentSizeOf:196 ofRows:1];
	
	STAssertEquals(actual, CGSizeMake(320, 196), @"actual: %@ expected: %@", NSStringFromCGSize(actual), NSStringFromCGSize(CGSizeMake(320, 196)));
	
	[theBoxSize release];
}

- (void) testContentSizeOfRowsTwo
{
	CGSize size = CGSizeMake(320, 196);
	TheBoxSize *theBoxSize = [[TheBoxSize alloc] initWithSize:size];
	
	CGSize actual = [theBoxSize contentSizeOf:196 ofRows:2];
	
	STAssertEquals(actual, CGSizeMake(320, 196 * 2), nil);
	
	[theBoxSize release];
}

- (void) testContentSizeOfRowsOdd
{
	CGSize size = CGSizeMake(320, 392);
	TheBoxSize *theBoxSize = [[TheBoxSize alloc] initWithSize:size];
	
	CGSize actual = [theBoxSize contentSizeOf:196 ofRows:3];
	
	STAssertEquals(actual, CGSizeMake(320, 196 * 3), nil);
	
	[theBoxSize release];
}


- (void) testContentSizeOfRowsEven
{
	CGSize size = CGSizeMake(320, 392);
	TheBoxSize *theBoxSize = [[TheBoxSize alloc] initWithSize:size];
	
	CGSize actual = [theBoxSize contentSizeOf:196 ofRows:4];
	
	STAssertEquals(actual, CGSizeMake(320, 196 * 4), nil);
	
	[theBoxSize release];
}

- (void) testContentSizeOfColumnsZero
{
	CGSize size = CGSizeMake(320, 392);
	TheBoxSize *theBoxSize = [[TheBoxSize alloc] initWithSize:size];
	
	CGSize actual = [theBoxSize contentSizeOf:160 ofColumns:0];
	
	STAssertEquals(actual, CGSizeMake(0, 392), @"actual: %@ expected: %@", NSStringFromCGSize(actual), NSStringFromCGSize(CGSizeMake(320, 0)));
	
	[theBoxSize release];
}

- (void) testContentSizeOfColumnsOne
{
	CGSize size = CGSizeMake(320, 392);
	TheBoxSize *theBoxSize = [[TheBoxSize alloc] initWithSize:size];
	
	CGSize actual = [theBoxSize contentSizeOf:160 ofColumns:1];
	
	STAssertEquals(actual, CGSizeMake(160, 392), @"actual: %@ expected: %@", NSStringFromCGSize(actual), NSStringFromCGSize(CGSizeMake(320, 196)));
	
	[theBoxSize release];
}

- (void) testContentSizeOfColumnsTwo
{
	CGSize size = CGSizeMake(320, 392);
	TheBoxSize *theBoxSize = [[TheBoxSize alloc] initWithSize:size];
	
	CGSize actual = [theBoxSize contentSizeOf:160 ofColumns:2];
	
	STAssertEquals(actual, CGSizeMake(160*2, 392), nil);
	
	[theBoxSize release];
}

- (void) testContentSizeOfColumnsdd
{
	CGSize size = CGSizeMake(320, 392);
	TheBoxSize *theBoxSize = [[TheBoxSize alloc] initWithSize:size];
	
	CGSize actual = [theBoxSize contentSizeOf:160 ofColumns:3];
	
	STAssertEquals(actual, CGSizeMake(160*3, 392), nil);
	
	[theBoxSize release];
}


- (void) testContentSizeOfColumnsEven
{
	CGSize size = CGSizeMake(320, 392);
	TheBoxSize *theBoxSize = [[TheBoxSize alloc] initWithSize:size];
	
	CGSize actual = [theBoxSize contentSizeOf:160 ofColumns:4];
	
	STAssertEquals(actual, CGSizeMake(160*4, 392), nil);
	
	[theBoxSize release];
}


@end
