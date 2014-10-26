//
//  Copyright 2012 TheBox 
//  All rights reserved.
//
//  This file is part of TheBox
//
//  Created by Markos Charatzas on 22/04/2012.
//

#import <XCTest/XCTest.h>
#import "OCMock.h"
#import "OCMArg.h"
#import "VLBGridView.h"
#import "VLBGridViewDatasource.h"
#import "VLBGridViewDelegate.h"
#import "VLBScrollView.h"

@interface VLBGridView (Testing) <VLBScrollViewDelegate>
- (id)initWith:(NSMutableDictionary*)frames;
- (void)setScrollView:(VLBScrollView *)scrollView;
-(NSUInteger)numberOfViewsInScrollView:(VLBScrollView *)scrollView;
@end

@interface VLBGridViewTest : XCTestCase {
	
}
@end

@implementation VLBGridViewTest

-(void)testGivenAssignedDatasourceAssertNumberOfViewsInGridView
{
    id mockedDatasource = [OCMockObject niceMockForProtocol:@protocol(VLBGridViewDatasource)];
    id mockedScrollView = [OCMockObject niceMockForClass:[VLBScrollView class]];
    
    VLBGridView * gridView = [[VLBGridView alloc] init];
    [gridView awakeFromNib];
    [gridView setScrollView:mockedScrollView];
    gridView.datasource = mockedDatasource;
    
    NSUInteger one = 1;
    
    [[[mockedDatasource expect] andReturnValue:OCMOCK_VALUE(one)] numberOfViewsInGridView:gridView];
        
    XCTAssertEqual([gridView numberOfViewsInScrollView:mockedScrollView], one);
}

-(void)testGivenAssignedDatasourceAssertNumberOfViewsInGridViewAtIndex
{
    id mockedDatasource = [OCMockObject niceMockForProtocol:@protocol(VLBGridViewDatasource)];
    id mockedScrollView = [OCMockObject niceMockForClass:[VLBScrollView class]];
    
    NSMutableDictionary *frames = 
        [NSMutableDictionary dictionaryWithObject:[NSNumber numberWithInt:0] 
                                           forKey:[NSValue valueWithCGRect:[mockedScrollView frame]]];
    
    VLBGridView * gridView = [[VLBGridView alloc] initWith:frames];
    [gridView awakeFromNib];
    gridView.datasource = mockedDatasource;
    
    NSUInteger one = 1;
    
    [[[mockedDatasource expect] andReturnValue:OCMOCK_VALUE(one)] numberOfViewsInGridView:gridView atIndex:0];
    
    XCTAssertEqual([gridView numberOfViewsInScrollView:nil], one);
}

-(void)testGivenViewWillAppearAssertViewWillAppearOnDelegate
{
    VLBScrollView * view = [[VLBScrollView alloc] init];
    id mockedDelegate = [OCMockObject niceMockForProtocol:@protocol(VLBGridViewDelegate)];

    VLBGridView * gridView = [[VLBGridView alloc] init];
    gridView.delegate = mockedDelegate;
    
    [[mockedDelegate expect] gridView:gridView viewOf:view atRow:0 atIndex:0 willAppear:nil];
    
    [gridView viewInScrollView:view willAppear:nil atIndex:0];
    
    [mockedDelegate verify];
}


@end
