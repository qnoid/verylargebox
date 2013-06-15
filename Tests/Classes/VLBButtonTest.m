//
//  VLBButtonTest.m
//  thebox
//
//  Created by Markos Charatzas on 19/11/2012.
//  Copyright (c) 2012 TheBox. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import <QuartzCore/QuartzCore.h>
#import "VLBButton.h"
#import "VLBView.h"
#import "VLBViews.h"

@interface VLBButtonTest : SenTestCase

@end

@implementation VLBButtonTest

-(void)testTrue
{
    VLBButton * button = [[VLBButton alloc] initWithFrame:CGRectZero];

    [button vlb_border];

    STAssertEquals(button.layer.borderColor, [UIColor blackColor].CGColor, nil);
    STAssertEquals(button.layer.borderWidth, 1.0f, nil);
}
@end
