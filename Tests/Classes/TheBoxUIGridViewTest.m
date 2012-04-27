/**
 *  Copyright 2012 TheBox 
 *  All rights reserved.
 *
 *  This file is part of TheBox
 *
 *  Created by Markos Charatzas (@qnoid)  on 22/04/2012.
 *  Contributor(s): .-
 */
#import <SenTestingKit/SenTestingKit.h>
#import "OCMock.h"
#import "OCMArg.h"
#import "TheBoxUIGridView.h"
#import "TheBoxUIGridViewDatasource.h"
#import "TheBoxUIGridViewDelegate.h"

@interface TheBoxUIGridView (Testing)
- (id)initWith:(NSMutableDictionary*)frames;
- (void)setScrollView:(TheBoxUIScrollView*)scrollView;
-(NSUInteger)numberOfViewsInScrollView:(TheBoxUIScrollView *)scrollView;
-(CGRect)frameOf:(TheBoxUIScrollView *)scrollView atIndex:(NSInteger)index;
@end

@interface TheBoxUIGridViewTest : SenTestCase {
	
}
@end

@implementation TheBoxUIGridViewTest


-(void)assertViewFrame:(CGRect)frame forIndex:(NSUInteger)index givenScrollView:(CGFloat)cellWidth withBounds:(CGRect)bounds
{
    id mockedScrollView = [OCMockObject niceMockForClass:[TheBoxUIScrollView class]];
    id mockedDelegate = [OCMockObject niceMockForProtocol:@protocol(TheBoxUIGridViewDelegate)];
    id mockedDatasource = [OCMockObject niceMockForProtocol:@protocol(TheBoxUIGridViewDatasource)];
    
    [[[mockedScrollView expect] andReturnValue:OCMOCK_VALUE(frame)] frame];
    [[[mockedScrollView expect] andReturnValue:OCMOCK_VALUE(bounds)] bounds];
    
    TheBoxUIGridView* gridView = [[TheBoxUIGridView alloc] init];
    
    NSUInteger one = 1;
    [[[mockedDatasource expect] andReturnValue:OCMOCK_VALUE(one)] numberOfViewsInGridView:gridView atIndex:index];
    [[[mockedDelegate expect] andReturnValue:OCMOCK_VALUE(cellWidth)] whatCellWidth:gridView];
    
    gridView.delegate = mockedDelegate;
    gridView.datasource = mockedDatasource;
    
    CGRect actual = [gridView frameOf:mockedScrollView atIndex:index];
    
    STAssertTrue(CGRectEqualToRect(actual, CGRectMake(0, 0, 160, 192)), @"actual: %@", NSStringFromCGRect(actual));
}

-(void)testGivenAssignedDatasourceAssertNumberOfViewsInGridView
{
    id mockedDatasource = [OCMockObject niceMockForProtocol:@protocol(TheBoxUIGridViewDatasource)];
    id mockedScrollView = [OCMockObject niceMockForClass:[TheBoxUIScrollView class]];
    
    TheBoxUIGridView* gridView = [[TheBoxUIGridView alloc] init];
    [gridView awakeFromNib];
    [gridView setScrollView:mockedScrollView];
    gridView.datasource = mockedDatasource;
    
    NSUInteger one = 1;
    
    [[[mockedDatasource expect] andReturnValue:OCMOCK_VALUE(one)] numberOfViewsInGridView:gridView];
        
    STAssertEquals([gridView numberOfViewsInScrollView:mockedScrollView], one, nil);
}

-(void)testGivenAssignedDatasourceAssertNumberOfViewsInGridViewAtIndex
{
    id mockedDatasource = [OCMockObject niceMockForProtocol:@protocol(TheBoxUIGridViewDatasource)];
    id mockedScrollView = [OCMockObject niceMockForClass:[TheBoxUIScrollView class]];
    
    NSMutableDictionary *frames = 
        [NSMutableDictionary dictionaryWithObject:[NSNumber numberWithInt:0] 
                                           forKey:[NSValue valueWithCGRect:[mockedScrollView frame]]];
    
    TheBoxUIGridView* gridView = [[TheBoxUIGridView alloc] initWith:frames];
    [gridView awakeFromNib];
    gridView.datasource = mockedDatasource;
    
    NSUInteger one = 1;
    
    [[[mockedDatasource expect] andReturnValue:OCMOCK_VALUE(one)] numberOfViewsInGridView:gridView atIndex:0];
    
    STAssertEquals([gridView numberOfViewsInScrollView:nil], one, nil);
}

-(void)testGivenScrollViewDatasourceWithZeroColumnsAssertViewFrameForIndex
{
    id mockedScrollView = [OCMockObject niceMockForClass:[TheBoxUIScrollView class]];
    id mockedDatasource = [OCMockObject niceMockForProtocol:@protocol(TheBoxUIGridViewDatasource)];

    CGRect frame = CGRectMake(0, 0, 320, 192);
    CGRect bounds = CGRectMake(0, 0, 320, 192);
    
    [[[mockedScrollView expect] andReturnValue:OCMOCK_VALUE(frame)] frame];
    [[[mockedScrollView expect] andReturnValue:OCMOCK_VALUE(bounds)] bounds];
    
    TheBoxUIGridView* gridView = [[TheBoxUIGridView alloc] init];
    gridView.datasource = mockedDatasource;
    
    NSUInteger zero = 0;
    [[[mockedDatasource expect] andReturnValue:OCMOCK_VALUE(zero)] numberOfViewsInGridView:gridView atIndex:0];
    
    CGRect actual = [gridView frameOf:mockedScrollView atIndex:0];
    
    STAssertTrue(CGRectEqualToRect(actual, CGRectMake(0, 0, 0, 192)), @"actual: %@", NSStringFromCGRect(actual));
}

//Ignore for some reason evaluation of index * [self.delegate whatCellWidth:self] returns always 0;
//-(void)testGivenScrollViewWithBoundsAtZeroAssertViewFrameForIndex
//{
//    CGRect frame = CGRectMake(0, 0, 320, 192);
//    CGRect bounds = CGRectMake(0, 0, 320, 192);
//
//    CGFloat cellWidth = 160.0;
//    
//    [self assertViewFrame:frame forIndex:0 givenScrollView:cellWidth withBounds:bounds];
//}

//Ignore for some reason evaluation of index * [self.delegate whatCellWidth:self] returns always 0;
//-(void)testGivenScrollViewWithBoundsAtZeroAssertViewFrameForIndexOne
//{
//    CGRect frame = CGRectMake(0, 0, 320, 192);
//    CGRect bounds = CGRectMake(0, 0, 320, 192);
//    
//    CGFloat cellWidth = 160.0;
//    
//    [self assertViewFrame:frame forIndex:1 givenScrollView:cellWidth withBounds:bounds];
//}

@end
