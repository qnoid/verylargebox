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

@interface TheBoxVisibleStrategyTest : SenTestCase {
	
}
@end

@implementation TheBoxVisibleStrategyTest

-(void)testGivenBoundsWithLessWidthThanContentSizeAssertVisibleBoundsStayTheSame
{
    TheBoxVisibleStrategy *visibleStrategy = [TheBoxVisibleStrategy newVisibleStrategyOnWidth:1.0f];    
    CGSize contentSize = CGSizeMake(2, 0);
    CGRect bounds = CGRectMake(0, 0, 1, 0);
    
    CGRect visibleBounds = [visibleStrategy visibleBounds:bounds withinContentSize:contentSize];
    
    STAssertTrue(CGRectEqualToRect(bounds, visibleBounds), @"expected: %@ actual: %@", NSStringFromCGRect(bounds), NSStringFromCGRect(visibleBounds));
}

-(void)testGivenBoundsWithLessHeightThanContentSizeAssertVisibleBoundsStayTheSame
{
    TheBoxVisibleStrategy *visibleStrategy = [TheBoxVisibleStrategy newVisibleStrategyOnHeight:1.0f];
    
    CGSize contentSize = CGSizeMake(0, 2);
    CGRect bounds = CGRectMake(0, 0, 0, 1);
    
    CGRect visibleBounds = [visibleStrategy visibleBounds:bounds withinContentSize:contentSize];
    
    STAssertTrue(CGRectEqualToRect(bounds, visibleBounds), @"expected: %@ actual: %@", NSStringFromCGRect(bounds), NSStringFromCGRect(visibleBounds));
}

-(void)testGivenBoundsWidthReachesContentSizeAssertVisibleBoundsStayTheSame
{
    TheBoxVisibleStrategy *visibleStrategy = [TheBoxVisibleStrategy newVisibleStrategyOnWidth:1.0f];    
    CGSize contentSize = CGSizeMake(2, 0);
    CGRect bounds = CGRectMake(1, 0, 1, 0);
    
    CGRect visibleBounds = [visibleStrategy visibleBounds:bounds withinContentSize:contentSize];
    
    STAssertTrue(CGRectEqualToRect(bounds, visibleBounds), @"expected: %@ actual: %@", NSStringFromCGRect(bounds), NSStringFromCGRect(visibleBounds));
}

-(void)testGivenBoundsHeightReachesContentSizeAssertVisibleBoundsStayTheSame
{
    TheBoxVisibleStrategy *visibleStrategy = [TheBoxVisibleStrategy newVisibleStrategyOnHeight:1.0f];
    CGSize contentSize = CGSizeMake(0, 2);
    CGRect bounds = CGRectMake(0, 1, 0, 1);
    
    CGRect visibleBounds = [visibleStrategy visibleBounds:bounds withinContentSize:contentSize];
    
    STAssertTrue(CGRectEqualToRect(bounds, visibleBounds), @"expected: %@ actual: %@", NSStringFromCGRect(bounds), NSStringFromCGRect(visibleBounds));
}

-(void)testGivenBoundsWidthBouncesOfContentSizeAssertVisibleBoundsWithinContentSize
{
    TheBoxVisibleStrategy *visibleStrategy = [TheBoxVisibleStrategy newVisibleStrategyOnWidth:1.0f];    
    CGSize contentSize = CGSizeMake(1, 0);
    
    CGRect visibleBounds = [visibleStrategy visibleBounds:CGRectMake(1, 0, 1, 0) withinContentSize:contentSize];
    
    CGRect bounds = CGRectMake(0, 0, 1, 0);
    STAssertTrue(CGRectEqualToRect(bounds, visibleBounds), @"expected: %@ actual: %@", NSStringFromCGRect(bounds), NSStringFromCGRect(visibleBounds));
}

/**
 This is a case where the scroll view has bouncing enabling thus the user 
 will end up scrolling past the allowed visible bounds causing an invalid maximum index
 */
-(void)testGivenDidScrollBouncesOutsideContentAssertVisibleBoundsAreLimitedToMaximumAllowedWidth
{
    TheBoxVisibleStrategy *visibleStrategy = [TheBoxVisibleStrategy newVisibleStrategyOnWidth:160.0f];
    CGSize contentSize = CGSizeMake(640, 0);
    
    CGRect visibleBounds = [visibleStrategy visibleBounds:CGRectMake(481, 0, 160, 0) withinContentSize:contentSize];
    
    CGRect bounds = CGRectMake(480, 0, 160, 0);
    STAssertTrue(CGRectEqualToRect(bounds, visibleBounds), @"expected: %@ actual: %@", NSStringFromCGRect(bounds), NSStringFromCGRect(visibleBounds));
}

-(void)testGivenBoundsHeightBouncesOfContentSizeAssertVisibleBoundsWithinContentSize
{
    TheBoxVisibleStrategy *visibleStrategy = [TheBoxVisibleStrategy newVisibleStrategyOnHeight:1.0f];   
    CGSize contentSize = CGSizeMake(0, 1);
    
    CGRect visibleBounds = [visibleStrategy visibleBounds:CGRectMake(0, 1, 0, 1) withinContentSize:contentSize];
    
    CGRect bounds = CGRectMake(0, 0, 0, 1);
    STAssertTrue(CGRectEqualToRect(bounds, visibleBounds), @"expected: %@ actual: %@", NSStringFromCGRect(bounds), NSStringFromCGRect(visibleBounds));
}

-(void)testGivenDidScrollBouncesOutsideContentAssertVisibleBoundsAreLimitedToMaximumAllowedHeight
{
    TheBoxVisibleStrategy *visibleStrategy = [TheBoxVisibleStrategy newVisibleStrategyOnHeight:240.0f];
    CGSize contentSize = CGSizeMake(0, 960);
    CGRect bounds = CGRectMake(0, 720, 0, 240);
    
    CGRect visibleBounds = [visibleStrategy visibleBounds:CGRectMake(0, 721, 0, 240) withinContentSize:contentSize];
    
    STAssertTrue(CGRectEqualToRect(bounds, visibleBounds), @"expected: %@ actual: %@", NSStringFromCGRect(bounds), NSStringFromCGRect(visibleBounds));
}

@end
