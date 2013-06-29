//
//  VLBButtonTest.m
//  thebox
//
//  Created by Markos Charatzas on 19/11/2012.
//  Copyright (c) 2012 (verylargebox.com). All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import <QuartzCore/QuartzCore.h>
#import "VLBButton.h"
#import "VLBView.h"
#import "VLBViews.h"

@interface VLBViewTest : SenTestCase

@end

@implementation VLBViewTest

-(void)testTrue
{
    UIView * view = [[UIView alloc] initWithFrame:CGRectZero];

    [view vlb_border];

    STAssertEquals(view.layer.borderColor, [UIColor blackColor].CGColor, nil);
    STAssertEquals(view.layer.borderWidth, 1.0f, nil);
}
@end
