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
#import "OCMockObject.h"
#import "TheBoxUIScrollView.h"
#import "VisibleStrategy.h"

@interface TheBoxUIScrollView (Testing)
@property(nonatomic) id<VisibleStrategy> visibleStrategy;
-(void)displayViewsWithinBounds:(CGRect)bounds;
@end

@interface TestVisibleStrategy : NSObject <VisibleStrategy>
@property(nonatomic, unsafe_unretained) CGRect bounds;
@end

@implementation TestVisibleStrategy

@synthesize bounds = _bounds;
@synthesize visibleViews;
@synthesize maximumVisibleIndex;
@synthesize minimumVisibleIndex;
@synthesize delegate;

- (NSUInteger)minimumVisible:(CGPoint)bounds{
return 0;
}

- (NSUInteger)maximumVisible:(CGRect)bounds{
return 0;
}

-(BOOL)isVisible:(NSInteger) index{
    return YES;
}

-(void)willAppear:(CGRect)bounds{
    _bounds = bounds;
}
@end

@interface TheBoxUIScrollViewTest : SenTestCase {
	
}
@end

@implementation TheBoxUIScrollViewTest

-(void)testGivenLayoutSubviewsAssertVisibleBoundsWidth
{
    TestVisibleStrategy *visibleStrategy = [[TestVisibleStrategy alloc] init];
    
    TheBoxUIScrollView* scrollView = [[TheBoxUIScrollView alloc] init];
    scrollView.contentSize = CGSizeMake(640, 0);
    scrollView.visibleStrategy = visibleStrategy;
    
    [scrollView displayViewsWithinBounds:CGRectMake(0, 0, 320, 0)];
    
    CGRect bounds = CGRectMake(0, 0, 320, 0);
    STAssertTrue(CGRectEqualToRect(bounds, visibleStrategy.bounds), @"expected: %@ actual: %@", NSStringFromCGRect(bounds), NSStringFromCGRect(visibleStrategy.bounds));
}

-(void)testGivenLayoutSubviewsAssertVisibleBoundsHeight
{
    TestVisibleStrategy *visibleStrategy = [[TestVisibleStrategy alloc] init];
    
    TheBoxUIScrollView* scrollView = [[TheBoxUIScrollView alloc] init];
    scrollView.contentSize = CGSizeMake(0, 720);
    scrollView.visibleStrategy = visibleStrategy;
    
    [scrollView displayViewsWithinBounds:CGRectMake(0, 0, 0, 240)];
    
    CGRect bounds = CGRectMake(0, 0, 0, 240);
    STAssertTrue(CGRectEqualToRect(bounds, visibleStrategy.bounds), @"expected: %@ actual: %@", NSStringFromCGRect(bounds), NSStringFromCGRect(visibleStrategy.bounds));
}

-(void)testGivenDidScrollHorizontallyAssertVisibleBoundsWidth
{
    TestVisibleStrategy *visibleStrategy = [[TestVisibleStrategy alloc] init];
    
    TheBoxUIScrollView* scrollView = [[TheBoxUIScrollView alloc] init];
    scrollView.contentSize = CGSizeMake(640, 0);
    scrollView.visibleStrategy = visibleStrategy;
        
    [scrollView displayViewsWithinBounds:CGRectMake(480, 0, 160, 0)];
    
    CGRect bounds = CGRectMake(480, 0, 160, 0);
    STAssertTrue(CGRectEqualToRect(bounds, visibleStrategy.bounds), @"expected: %@ actual: %@", NSStringFromCGRect(bounds), NSStringFromCGRect(visibleStrategy.bounds));
}

-(void)testGivenDidScrollVerticallyAssertVisibleBoundsHeight
{
    TestVisibleStrategy *visibleStrategy = [[TestVisibleStrategy alloc] init];
    
    TheBoxUIScrollView* scrollView = [[TheBoxUIScrollView alloc] init];
    scrollView.contentSize = CGSizeMake(0, 960);
    scrollView.visibleStrategy = visibleStrategy;
    
    [scrollView displayViewsWithinBounds:CGRectMake(0, 720, 0, 240)];
    
    CGRect bounds = CGRectMake(0, 720, 0, 240);
    STAssertTrue(CGRectEqualToRect(bounds, visibleStrategy.bounds), @"expected: %@ actual: %@", NSStringFromCGRect(bounds), NSStringFromCGRect(visibleStrategy.bounds));
}

-(void)testGivenDidScrollBouncesAtMaximumContentSizeAssertVisibleBoundsAreLimitedToMaximumAllowedWidth
{
    TestVisibleStrategy *visibleStrategy = [[TestVisibleStrategy alloc] init];
    
    TheBoxUIScrollView* scrollView = [[TheBoxUIScrollView alloc] init];
    scrollView.contentSize = CGSizeMake(640, 0);
    scrollView.visibleStrategy = visibleStrategy;
    
    [scrollView displayViewsWithinBounds:CGRectMake(640, 0, 160, 0)];
    
    CGRect bounds = CGRectMake(480, 0, 160, 0);
    STAssertTrue(CGRectEqualToRect(bounds, visibleStrategy.bounds), @"expected: %@ actual: %@", NSStringFromCGRect(bounds), NSStringFromCGRect(visibleStrategy.bounds));
}

/**
 This is a case where the scroll view has bouncing enabling thus the user 
 will end up scrolling past the allowed visible bounds causing an invalid maximum index
 */
-(void)testGivenDidScrollBouncesOutsideContentAssertVisibleBoundsAreLimitedToMaximumAllowedWidth
{
    TestVisibleStrategy *visibleStrategy = [[TestVisibleStrategy alloc] init];
    
    TheBoxUIScrollView* scrollView = [[TheBoxUIScrollView alloc] init];
    scrollView.contentSize = CGSizeMake(640, 0);
    scrollView.visibleStrategy = visibleStrategy;
    
    [scrollView displayViewsWithinBounds:CGRectMake(481, 0, 160, 0)];
    
    CGRect bounds = CGRectMake(480, 0, 160, 0);
    STAssertTrue(CGRectEqualToRect(bounds, visibleStrategy.bounds), @"expected: %@ actual: %@", NSStringFromCGRect(bounds), NSStringFromCGRect(visibleStrategy.bounds));
}

-(void)testGivenDidScrollBouncesAtMaximumContentAssertVisibleBoundsAreLimitedToMaximumAllowedHeight
{
    TestVisibleStrategy *visibleStrategy = [[TestVisibleStrategy alloc] init];
    
    TheBoxUIScrollView* scrollView = [[TheBoxUIScrollView alloc] init];
    scrollView.contentSize = CGSizeMake(0, 960);
    scrollView.visibleStrategy = visibleStrategy;
    
    [scrollView displayViewsWithinBounds:CGRectMake(0, 960, 0, 240)];
    
    CGRect bounds = CGRectMake(0, 720, 0, 240);
    STAssertTrue(CGRectEqualToRect(bounds, visibleStrategy.bounds), @"expected: %@ actual: %@", NSStringFromCGRect(bounds), NSStringFromCGRect(visibleStrategy.bounds));
}

-(void)testGivenDidScrollBouncesOutsideContentAssertVisibleBoundsAreLimitedToMaximumAllowedHeight
{
    TestVisibleStrategy *visibleStrategy = [[TestVisibleStrategy alloc] init];
    
    TheBoxUIScrollView* scrollView = [[TheBoxUIScrollView alloc] init];
    scrollView.contentSize = CGSizeMake(0, 960);
    scrollView.visibleStrategy = visibleStrategy;
    
    [scrollView displayViewsWithinBounds:CGRectMake(0, 721, 0, 240)];
    
    CGRect bounds = CGRectMake(0, 720, 0, 240);
    STAssertTrue(CGRectEqualToRect(bounds, visibleStrategy.bounds), @"expected: %@ actual: %@", NSStringFromCGRect(bounds), NSStringFromCGRect(visibleStrategy.bounds));
}

@end
