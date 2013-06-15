//
//  Copyright (c) 2010 (verylargebox.com). All rights reserved.
//  All rights reserved.
//
//  This file is part of TheBox
//
//  Created by Markos Charatzas on 04/04/2011.
//
//

#import <SenTestingKit/SenTestingKit.h>
#import "VLBSize.h"

@interface VLBSizeTest : SenTestCase
{
}

@end


@implementation VLBSizeTest

- (void) testContentSizeOfRowsZero
{
	CGSize size = CGSizeMake(320, 392);
	NSObject<VLBSize> *theBoxSize = [[VLBSizeInHeight alloc] initWithSize:size];
	
	CGSize actual = [theBoxSize sizeOf:0 size:196];
	
	STAssertEquals(actual, CGSizeZero, @"actual: %@ expected: %@", NSStringFromCGSize(actual), NSStringFromCGSize(CGSizeZero));
	
}

- (void) testContentSizeOfRowsOne
{
	CGSize size = CGSizeMake(320, 392);
	NSObject<VLBSize> *theBoxSize = [[VLBSizeInHeight alloc] initWithSize:size];
	
	CGSize actual = [theBoxSize sizeOf:1 size:196];
	
	STAssertEquals(actual, CGSizeMake(320, 196), @"actual: %@ expected: %@", NSStringFromCGSize(actual), NSStringFromCGSize(CGSizeMake(320, 196)));
	
}

- (void) testContentSizeOfRowsTwo
{
	CGSize size = CGSizeMake(320, 196);
	NSObject<VLBSize> *theBoxSize = [[VLBSizeInHeight alloc] initWithSize:size];
	
	CGSize actual = [theBoxSize sizeOf:2 size:196];
	
	STAssertEquals(actual, CGSizeMake(320, 196 * 2), nil);
	
}

- (void) testContentSizeOfRowsOdd
{
	CGSize size = CGSizeMake(320, 392);
	NSObject<VLBSize> *theBoxSize = [[VLBSizeInHeight alloc] initWithSize:size];
	
	CGSize actual = [theBoxSize sizeOf:3 size:196];
	
	STAssertEquals(actual, CGSizeMake(320, 196 * 3), nil);
	
}


- (void) testContentSizeOfRowsEven
{
	CGSize size = CGSizeMake(320, 392);
	NSObject<VLBSize> *theBoxSize = [[VLBSizeInHeight alloc] initWithSize:size];
	
	CGSize actual = [theBoxSize sizeOf:4 size:196];
	
	STAssertEquals(actual, CGSizeMake(320, 196 * 4), nil);
	
}

- (void) testContentSizeOfColumnsZero
{
	CGSize size = CGSizeMake(320, 392);
	NSObject<VLBSize> *theBoxSize = [[VLBSizeInWidth alloc] initWithSize:size];
	
	CGSize actual = [theBoxSize sizeOf:0 size:160];
	
	STAssertEquals(actual, CGSizeZero, @"actual: %@ expected: %@", NSStringFromCGSize(actual), NSStringFromCGSize(CGSizeZero));
	
}

- (void) testContentSizeOfColumnsOne
{
	CGSize size = CGSizeMake(320, 392);
	NSObject<VLBSize> *theBoxSize = [[VLBSizeInWidth alloc] initWithSize:size];
	
	CGSize actual = [theBoxSize sizeOf:1 size:160];
	
	STAssertEquals(actual, CGSizeMake(160, 392), @"actual: %@ expected: %@", NSStringFromCGSize(actual), NSStringFromCGSize(CGSizeMake(160, 392)));
	
}

- (void) testContentSizeOfColumnsTwo
{
	CGSize size = CGSizeMake(320, 392);
	NSObject<VLBSize> *theBoxSize = [[VLBSizeInWidth alloc] initWithSize:size];
	
	CGSize actual = [theBoxSize sizeOf:2 size:160];
	
	STAssertEquals(actual, CGSizeMake(160*2, 392), nil);
	
}

- (void) testContentSizeOfColumnsdd
{
	CGSize size = CGSizeMake(320, 392);
	NSObject<VLBSize> *theBoxSize = [[VLBSizeInWidth alloc] initWithSize:size];
	
	CGSize actual = [theBoxSize sizeOf:3 size:160];
	
	STAssertEquals(actual, CGSizeMake(160*3, 392), nil);
	
}


- (void) testContentSizeOfColumnsEven
{
	CGSize size = CGSizeMake(320, 392);
	NSObject<VLBSize> *theBoxSize = [[VLBSizeInWidth alloc] initWithSize:size];
	
	CGSize actual = [theBoxSize sizeOf:4 size:160];
	
	STAssertEquals(actual, CGSizeMake(160*4, 392), nil);
	
}


@end
