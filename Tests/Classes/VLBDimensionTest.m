//
//  VLBDimensionTest.m
//  verylargebox
//
//  Created by Markos Charatzas on 12/01/2013.
//  Copyright (c) 2013 (verylargebox.com). All rights reserved.
//

#import <XCTest/XCTest.h>
#import "VLBSize.h"

@interface VLBDimensionTest : XCTestCase

@end

@implementation VLBDimensionTest

- (void) testMoveCloserToWholeZero
{
	CGFloat width = 100;
    VLBWidth *dimension = [VLBWidth newWidth:width];
    
    CGPoint point = CGPointMake(0, 0);
    [dimension moveCloserToWhole:&point];
    
	XCTAssertTrue(point.x == 0);
}

- (void) testMoveCloserToWholeDown
{
	CGFloat width = 100;
    VLBWidth *dimension = [VLBWidth newWidth:width];
    
    CGPoint point = CGPointMake(50.0, 0);
    [dimension moveCloserToWhole:&point];
    
	XCTAssertTrue(point.x == 0);
}

- (void) testMoveCloserToWholeUp
{
	CGFloat width = 100;
    VLBWidth *dimension = [VLBWidth newWidth:width];
    
    CGPoint point = CGPointMake(50.1, 0);
    [dimension moveCloserToWhole:&point];
    
	XCTAssertTrue(point.x == 100);
}

- (void) testMoveCloserToWholeHundred
{
	CGFloat width = 100;
    VLBWidth *dimension = [VLBWidth newWidth:width];
    
    CGPoint point = CGPointMake(100, 0);
    [dimension moveCloserToWhole:&point];
    
	XCTAssertTrue(point.x == 100);
}

- (void) testMoveCloserToWholeThousand
{
	CGFloat width = 100;
    VLBWidth *dimension = [VLBWidth newWidth:width];
    
    CGPoint point = CGPointMake(1000, 0);
    [dimension moveCloserToWhole:&point];
    
	XCTAssertTrue(point.x == 1000);
}
@end
