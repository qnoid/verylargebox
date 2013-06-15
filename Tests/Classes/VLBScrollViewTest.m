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
#import "VLBScrollView.h"
#import "VLBScrollViewDatasource.h"
#import "VLBSize.h"
#import "VLBRecycleStrategy.h"
#import "VLBVisibleStrategy.h"

@interface VLBScrollView (Testing)
-(id)initWithFrame:(CGRect) frame size:(NSObject<VLBSize>*)size dimension:(NSObject<VLBDimension>*)dimension;
-(void)setVisibleStrategy:(id<VLBVisibleStrategy>)visibleStrategy;
-(id<VLBVisibleStrategy>)visibleStrategy;
-(void)setRecycleStrategy:(VLBRecycleStrategy *)recycleStrategy;
-(void)setContentView:(UIView*)contentView;
-(void)setTheBoxSize:(VLBSize *)size;
@end

@interface VLBScrollViewTest : SenTestCase {
	
}
@end

@implementation VLBScrollViewTest

-(void)testGivenInitWithFrameAssertContentViewAsSubview
{
    CGRect frame = CGRectMake(0, 0, 320, 196);
    VLBScrollView *theBoxScrollView = [[VLBScrollView alloc] initWithFrame:frame size:nil dimension:nil];
    
    STAssertTrue(1 == [theBoxScrollView.subviews count], nil);    
    UIView* contentView = [theBoxScrollView.subviews objectAtIndex:0];    
    STAssertTrue(CGRectEqualToRect(contentView.frame, CGRectMake(CGPointZero.x, CGPointZero.y, frame.size.width, frame.size.height)) , nil);
}

-(void)testGivenDelegateDatasourceSizeAssertTheBoxSizeOfIsCalledLayoutSubview
{
    id mockedDelegate = [OCMockObject niceMockForProtocol:@protocol(VLBScrollViewDelegate)];
    id mockedDatasource = [OCMockObject niceMockForProtocol:@protocol(VLBScrollViewDatasource)];
    id mockedSize = [OCMockObject niceMockForClass:[VLBSizeInWidth class]];

    CGFloat size = 160;

    VLBScrollView *theBoxScrollView = [[VLBScrollView alloc] initWithFrame:CGRectZero size:mockedSize dimension:[VLBWidth newWidth:size]];
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
    id mockedVisibleStrategy = [OCMockObject niceMockForClass:[VLBVisibleStrategy class]];
    id mockedRecycleStrategy = [OCMockObject mockForClass:[VLBRecycleStrategy class]];

    VLBScrollView *theBoxScrollView = [[VLBScrollView alloc] init];
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
