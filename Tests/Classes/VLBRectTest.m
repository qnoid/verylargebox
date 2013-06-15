//
//  Copyright (c) 2010 (verylargebox.com). All rights reserved.
//  All rights reserved.
//
//  This file is part of TheBox
//
//  Created by Markos Charatzas on 05/04/2011.
//
//

#import <SenTestingKit/SenTestingKit.h>
#import "VLBRect.h"

@interface VLBRectTest : SenTestCase {
	
}
@end

@implementation VLBRectTest

- (void) testFrameZero
{
    VLBRect *rect = [[VLBRect alloc] initWithFrame:CGRectMake(0, 0, 320, 196)];
	
	CGRect frame = [rect frame:0 minimumWidth:1 * 160];
	
	STAssertEquals(frame, CGRectMake(0, 0, 160, 196), nil);
	
}

- (void) testFrame 
{
    VLBRect *rect = [[VLBRect alloc] initWithFrame:CGRectMake(0, 0, 320, 196)];
	
	CGRect frame = [rect frame:1 minimumWidth:1 * 160];
	
	STAssertEquals(frame, CGRectMake(0, 196, 160, 196), nil);
	
}

- (void) testFrame2
{
    VLBRect *rect = [[VLBRect alloc] initWithFrame:CGRectMake(0, 0, 320, 196)];
	
	CGRect frame = [rect frame:2 minimumWidth:2 * 160];
	
	STAssertEquals(frame, CGRectMake(0, 196 * 2, 320, 196), nil);
	
}

- (void) testFrame4
{
    VLBRect *rect = [[VLBRect alloc] initWithFrame:CGRectMake(0, 0, 320, 196)];
	
	CGRect frame = [rect frame:4 minimumWidth:4 * 160];
	
	STAssertEquals(frame, CGRectMake(0, 196 *4, 320, 196), nil);
	
}

- (void) testIsWithinXorigin
{
    CGRect frame = CGRectMake(0, 0, 160, 196);
	CGRect visibleBounds = CGRectMake(0, 0, 320, 196);

    VLBRect *rect = [[VLBRect alloc] initWithFrame:frame];

	STAssertTrue([rect isVisibleWithinX:visibleBounds], nil);
	
}


@end
