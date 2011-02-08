/*
 *  Copyright 2010 The Box
 *  All rights reserved.
 *
 *  This file is part of TheBox
 *
 *  Created by Markos Charatzas <[firstname.lastname@gmail.com]> on 12/12/10.
 *  Contributor(s): .-
 */
   
#import <SenTestingKit/SenTestingKit.h>
#import <UIKit/UIKit.h>
#import "TheBoxBundle.h"
#import "Math.h"

@interface TheBoxBundleTest : SenTestCase {
	
}

@end

@implementation TheBoxBundleTest

-(void)testLoadView
{
	NSInteger threeTwenty = 320 - 320;
	NSInteger oneSixty = 160 - 320;
	NSInteger zero = 0 - 320;
	STAssertTrue(fmax(0, threeTwenty) == 0, [NSString stringWithFormat:@"actual %f", fmax(0, threeTwenty)]);
	STAssertTrue(fmax(0, oneSixty) == 0, [NSString stringWithFormat:@"actual %f", fmax(0, oneSixty)]);
	STAssertTrue(fmax(0, zero) == 0, [NSString stringWithFormat:@"actual %f", fmax(0, zero)]);
	STAssertTrue(fmax(0, 1) == 1, [NSString stringWithFormat:@"actual %f", fmax(0, 1)]);
}

@end
