//
//  VLBButtonTest.m
//  verylargebox
//
//  Created by Markos Charatzas on 19/11/2012.
//  Copyright (c) 2012 (verylargebox.com). All rights reserved.
//

#import <XCTest/XCTest.h>
#import <QuartzCore/QuartzCore.h>
#import "VLBButton.h"
#import "VLBView.h"
#import "VLBViews.h"

@interface VLBViewTest : XCTestCase

@end

@implementation VLBViewTest

-(void)testTrue
{
    UIView * view = [[UIView alloc] initWithFrame:CGRectZero];

    [view vlb_border];

    XCTAssertEqual(view.layer.borderColor, [UIColor blackColor].CGColor);
    XCTAssertEqual(view.layer.borderWidth, 1.0f);
}
@end
