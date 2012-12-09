//
//  TBButtonTest.m
//  thebox
//
//  Created by Markos Charatzas on 19/11/2012.
//  Copyright (c) 2012 TheBox. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import <QuartzCore/QuartzCore.h>
#import "TBButton.h"
#import "TBUIView.h"

@interface TBButtonTest : SenTestCase

@end

@implementation TBButtonTest

-(void)testTrue
{
    TBButton* button = [TBButton new];
    [button border];

    STAssertEquals(button.layer.borderColor, [UIColor blackColor].CGColor, nil);
    STAssertEquals(button.layer.borderWidth, 1.0f, nil);
}
@end
