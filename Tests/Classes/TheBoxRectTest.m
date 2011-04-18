/*
 *  Copyright 2010 TheBox
 *  All rights reserved.
 *
 *  This file is part of TheBox
 *
 *  Created by Markos Charatzas <[firstname.lastname@gmail.com]> on 05/04/2011.
 *  Contributor(s): .-
 */
#import <SenTestingKit/SenTestingKit.h>
#import "TheBoxRect.h"

@interface TheBoxRectTest : SenTestCase {
	
}
@end

@implementation TheBoxRectTest

- (void) testFrameZero
{
    TheBoxRect *rect = [[TheBoxRect alloc] initWithFrame:CGRectMake(0, 0, 320, 196)];
	
	CGRect frame = [rect frame:0 minimumWidth:1 * 160];
	
	STAssertEquals(frame, CGRectMake(0, 0, 160, 196), nil);
	
	[rect release];
}

- (void) testFrame 
{
    TheBoxRect *rect = [[TheBoxRect alloc] initWithFrame:CGRectMake(0, 0, 320, 196)];
	
	CGRect frame = [rect frame:1 minimumWidth:1 * 160];
	
	STAssertEquals(frame, CGRectMake(0, 196, 160, 196), nil);
	
	[rect release];
}

- (void) testFrame2
{
    TheBoxRect *rect = [[TheBoxRect alloc] initWithFrame:CGRectMake(0, 0, 320, 196)];
	
	CGRect frame = [rect frame:2 minimumWidth:2 * 160];
	
	STAssertEquals(frame, CGRectMake(0, 196 * 2, 320, 196), nil);
	
	[rect release];
}

- (void) testFrame4
{
    TheBoxRect *rect = [[TheBoxRect alloc] initWithFrame:CGRectMake(0, 0, 320, 196)];
	
	CGRect frame = [rect frame:4 minimumWidth:4 * 160];
	
	STAssertEquals(frame, CGRectMake(0, 196 *4, 320, 196), nil);
	
	[rect release];
}


@end