/**
 *  Copyright 2012 TheBox 
 *  All rights reserved.
 *
 *  This file is part of TheBox
 *
 *  Created by Markos Charatzas (@qnoid)  on 27/04/2012.
 *  Contributor(s): .-
 */
#import <SenTestingKit/SenTestingKit.h>
#import "OCMock.h"
#import "OCMArg.h"
#import "TheBoxUIScrollView.h"
#import "TheBoxUIScrollViewDatasource.h"
#import "TheBoxSize.h"
#import "TheBoxUIRecycleStrategy.h"
#import "TheBoxVisibleStrategy.h"

@interface TheBoxUIScrollView(Testing)
-(id)initWithFrame:(CGRect) frame size:(NSObject<TheBoxSize>*)size dimension:(NSObject<TheBoxDimension>*)dimension;
-(void)setVisibleStrategy:(id<VisibleStrategy>)visibleStrategy;
-(id<VisibleStrategy>)visibleStrategy;
-(void)setRecycleStrategy:(TheBoxUIRecycleStrategy*)recycleStrategy;
-(void)setContentView:(UIView*)contentView;
-(void)setTheBoxSize:(TheBoxSize*)size;
@end

@interface TheBoxUIScrollViewTest : SenTestCase {
	
}
@end

@implementation TheBoxUIScrollViewTest

-(void)testGivenInitWithFrameAssertContentViewAsSubview
{
    CGRect frame = CGRectMake(0, 0, 320, 196);
    TheBoxUIScrollView *theBoxScrollView = [[TheBoxUIScrollView alloc] initWithFrame:frame size:nil dimension:nil];
    
    STAssertTrue(1 == [theBoxScrollView.subviews count], nil);    
    UIView* contentView = [theBoxScrollView.subviews objectAtIndex:0];    
    STAssertTrue(CGRectEqualToRect(contentView.frame, CGRectMake(CGPointZero.x, CGPointZero.y, frame.size.width, frame.size.height)) , nil);
}

-(void)testGivenDelegateDatasourceSizeAssertTheBoxSizeOfIsCalledLayoutSubview
{
    id mockedDelegate = [OCMockObject niceMockForProtocol:@protocol(TheBoxUIScrollViewDelegate)];
    id mockedDatasource = [OCMockObject niceMockForProtocol:@protocol(TheBoxUIScrollViewDatasource)];
    id mockedSize = [OCMockObject niceMockForClass:[TheBoxSizeInWidth class]];

    CGFloat size = 160;

    TheBoxUIScrollView *theBoxScrollView = [[TheBoxUIScrollView alloc] initWithFrame:CGRectZero size:mockedSize dimension:[TheBoxWidth newWidth:size]];
    theBoxScrollView.scrollViewDelegate = mockedDelegate;
    theBoxScrollView.datasource = mockedDatasource;
    
    NSUInteger one = 1;
    [[[mockedDatasource expect] andReturnValue:OCMOCK_VALUE(one)] numberOfViewsInScrollView:theBoxScrollView];
    
    CGSize expectedContentSize = CGSizeMake(0, 0);
    [[[mockedSize expect] andReturnValue:OCMOCK_VALUE(expectedContentSize)] sizeOf:one size:size];

    [theBoxScrollView layoutSubviews];
    
    [mockedSize verify];
    STAssertTrue(CGSizeEqualToSize(theBoxScrollView.contentSize, expectedContentSize), @"actual: %s expected: %s", NSStringFromCGSize(theBoxScrollView.contentSize), NSStringFromCGSize(expectedContentSize));
}

-(void)testGivenSetNeedsLayoutAssertContentSubviewsRecycleAndRemovedFromSuperview
{
    UIView* contentView = [[UIView alloc] init];
    [contentView addSubview:[[UIView alloc] init]];
    [contentView addSubview:[[UIView alloc] init]];
    id mockedVisibleStrategy = [OCMockObject niceMockForClass:[TheBoxVisibleStrategy class]];
    id mockedRecycleStrategy = [OCMockObject mockForClass:[TheBoxUIRecycleStrategy class]];

    TheBoxUIScrollView *theBoxScrollView = [[TheBoxUIScrollView alloc] init];
    [theBoxScrollView setVisibleStrategy:mockedVisibleStrategy];
    [theBoxScrollView setRecycleStrategy:mockedRecycleStrategy];    
    [theBoxScrollView setContentView:contentView];
    
    [[[mockedVisibleStrategy expect] andReturn:nil] dimension];
    [[mockedRecycleStrategy expect] recycle:[contentView subviews]];
    [[mockedVisibleStrategy expect] delegate];
     
    [theBoxScrollView setNeedsLayout];
    
    STAssertTrue(0 == [[contentView subviews] count], @"expected: 0 actual: %d", [[contentView subviews] count] );
    STAssertEquals(theBoxScrollView, [[theBoxScrollView visibleStrategy] delegate], @"actual: %@", [[theBoxScrollView visibleStrategy] delegate]);
    
}
@end
