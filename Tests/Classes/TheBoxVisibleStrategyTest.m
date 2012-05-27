/**
 *  Copyright 2012 TheBox 
 *  All rights reserved.
 *
 *  This file is part of TheBox
 *
 *  Created by Markos Charatzas (@qnoid)  on 19/04/2012.
 *  Contributor(s): .-
 */
#import <SenTestingKit/SenTestingKit.h>
#import "VisibleStrategy.h"
#import "TheBoxVisibleStrategy.h"
#import "OCMock.h"
#import "OCMArg.h"

@interface TheBoxVisibleStrategy (Testing)
-(NSInteger)minimumVisibleIndex;
-(NSInteger)maximumVisibleIndex;
@end

@interface TheBoxVisibleStrategyTest : SenTestCase {
}
@end

@implementation TheBoxVisibleStrategyTest

-(void)testGivenNegativeMinimumIndexAssertFlooredToZero
{
    TheBoxVisibleStrategy *visibleStrategy = [[TheBoxVisibleStrategy alloc] init];
    [visibleStrategy minimumVisibleIndexShould:[ceilVisibleIndexAt(0) copy]];
    [visibleStrategy maximumVisibleIndexShould:[floorVisibleIndexAt(1) copy]];

    id partiallyMockedVisibleStrategy = [OCMockObject partialMockForObject:visibleStrategy];
    
    NSInteger negativeOne = -1;
    [[[partiallyMockedVisibleStrategy expect] andReturnValue:OCMOCK_VALUE(negativeOne)] minimumVisible:CGPointZero];
    
    [visibleStrategy layoutSubviews:CGRectZero];
    
    STAssertTrue(0 == [partiallyMockedVisibleStrategy minimumVisibleIndex], @"expected: 0 actual: %d", [partiallyMockedVisibleStrategy minimumVisibleIndex]);
}

-(void)testGivenGreaterMaximumIndexAssertCeil
{
    TheBoxVisibleStrategy *visibleStrategy = [[TheBoxVisibleStrategy alloc] init];
    [visibleStrategy minimumVisibleIndexShould:[ceilVisibleIndexAt(0) copy]];
    [visibleStrategy maximumVisibleIndexShould:[floorVisibleIndexAt(1) copy]];
    
    id partiallyMockedVisibleStrategy = [OCMockObject partialMockForObject:visibleStrategy];
    
    NSInteger two = 2;
    [[[partiallyMockedVisibleStrategy expect] andReturnValue:OCMOCK_VALUE(two)] maximumVisible:CGRectZero];
    
    [visibleStrategy layoutSubviews:CGRectZero];
    
    STAssertTrue(0 == [partiallyMockedVisibleStrategy maximumVisibleIndex], @"expected: 0 actual: %d", [partiallyMockedVisibleStrategy maximumVisibleIndex]);
}


@end
