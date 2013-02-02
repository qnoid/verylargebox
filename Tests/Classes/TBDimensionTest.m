//
//  TBDimensionTest.m
//  thebox
//
//  Created by Markos Charatzas on 12/01/2013.
//  Copyright (c) 2013 TheBox. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import "TheBoxSize.h"

@interface TBDimensionTest : SenTestCase

@end

@implementation TBDimensionTest

- (void) testMoveCloserToWholeZero
{
	CGFloat width = 100;
    TheBoxWidth *dimension = [TheBoxWidth newWidth:width];
    
    CGPoint point = CGPointMake(0, 0);
    [dimension moveCloserToWhole:&point];
    
	STAssertTrue(point.x == 0, nil);
}

- (void) testMoveCloserToWholeDown
{
	CGFloat width = 100;
    TheBoxWidth *dimension = [TheBoxWidth newWidth:width];
    
    CGPoint point = CGPointMake(50.0, 0);
    [dimension moveCloserToWhole:&point];
    
	STAssertTrue(point.x == 0, nil);
}

- (void) testMoveCloserToWholeUp
{
	CGFloat width = 100;
    TheBoxWidth *dimension = [TheBoxWidth newWidth:width];
    
    CGPoint point = CGPointMake(50.1, 0);
    [dimension moveCloserToWhole:&point];
    
	STAssertTrue(point.x == 100, nil);
}

- (void) testMoveCloserToWholeHundred
{
	CGFloat width = 100;
    TheBoxWidth *dimension = [TheBoxWidth newWidth:width];
    
    CGPoint point = CGPointMake(100, 0);
    [dimension moveCloserToWhole:&point];
    
	STAssertTrue(point.x == 100, nil);
}

- (void) testMoveCloserToWholeThousand
{
	CGFloat width = 100;
    TheBoxWidth *dimension = [TheBoxWidth newWidth:width];
    
    CGPoint point = CGPointMake(1000, 0);
    [dimension moveCloserToWhole:&point];
    
	STAssertTrue(point.x == 1000, nil);
}


@end
