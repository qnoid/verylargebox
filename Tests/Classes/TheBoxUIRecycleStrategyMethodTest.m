/*
 *  Copyright 2011 The Box
 *  All rights reserved.
 *
 *  This file is part of TheBox
 *
 *  Created by Markos Charatzas <[firstname.lastname@gmail.com]> on 15/10/11.
 *  Contributor(s): .-
 */
#import <SenTestingKit/SenTestingKit.h>
#import <UIKit/UIKit.h>
#import "PartiallyVisibleWithinX.h"

@interface TheBoxUIRecycleStrategyMethodTest : SenTestCase {
	
}

@end

@implementation TheBoxUIRecycleStrategyMethodTest

-(void)testIsVisibleWithinX
{
    CGRect frame = CGRectMake(0, 0, 160, 196);
	CGRect bounds = CGRectMake(0, 0, 320, 196);

	PartiallyVisibleWithinX *recycleMethod = [[PartiallyVisibleWithinX alloc]init];
    
    STAssertTrue([recycleMethod is:frame visibleIn:bounds], nil);
}

@end
