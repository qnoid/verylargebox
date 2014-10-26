//
//  Copyright (c) 2010 (verylargebox.com). All rights reserved.
//  All rights reserved.
//
//  This file is part of TheBox
//
//  Created by Markos Charatzas on 05/04/2011.
//
//

#import <XCTest/XCTest.h>
#import "VLBRect.h"

@interface VLBRectTest : XCTestCase {
    
}
@end

@implementation VLBRectTest

- (void) testFrameZero
{
    VLBRect *rect = [[VLBRect alloc] initWithFrame:CGRectMake(0, 0, 320, 196)];
    
    CGRect frame = [rect frame:0 minimumWidth:1 * 160];
    
    XCTAssertTrue(CGRectEqualToRect(frame, CGRectMake(0, 0, 160, 196)));
    
}

- (void) testFrame
{
    VLBRect *rect = [[VLBRect alloc] initWithFrame:CGRectMake(0, 0, 320, 196)];
    
    CGRect frame = [rect frame:1 minimumWidth:1 * 160];
    
    XCTAssertTrue(CGRectEqualToRect(frame, CGRectMake(0, 196, 160, 196)));
    
}

- (void) testFrame2
{
    VLBRect *rect = [[VLBRect alloc] initWithFrame:CGRectMake(0, 0, 320, 196)];
    
    CGRect frame = [rect frame:2 minimumWidth:2 * 160];
    
    XCTAssertTrue(CGRectEqualToRect(frame, CGRectMake(0, 196 * 2, 320, 196)));
    
}

- (void) testFrame4
{
    VLBRect *rect = [[VLBRect alloc] initWithFrame:CGRectMake(0, 0, 320, 196)];
    
    CGRect frame = [rect frame:4 minimumWidth:4 * 160];
    
    XCTAssertTrue(CGRectEqualToRect(frame, CGRectMake(0, 196 *4, 320, 196)));
    
}

- (void) testIsWithinXorigin
{
    CGRect frame = CGRectMake(0, 0, 160, 196);
    CGRect visibleBounds = CGRectMake(0, 0, 320, 196);
    
    VLBRect *rect = [[VLBRect alloc] initWithFrame:frame];
    
    XCTAssertTrue([rect isVisibleWithinX:visibleBounds]);
    
}


@end
