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
#import "TheBoxUIScrollView.h"

@interface TheBoxUIGridView (Testing) <TheBoxUIScrollViewDelegate>
- (id)initWith:(NSMutableDictionary*)frames;
- (void)setScrollView:(TheBoxUIScrollView*)scrollView;
-(NSUInteger)numberOfViewsInScrollView:(TheBoxUIScrollView *)scrollView;
@end

@interface TheBoxUIGridViewTest : SenTestCase {
	
}
@end

@implementation TheBoxUIGridViewTest

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

-(void)testGivenViewWillAppearAssertViewWillAppearOnDelegate
{
    TheBoxUIScrollView* view = [[TheBoxUIScrollView alloc] init];
    id mockedDelegate = [OCMockObject niceMockForProtocol:@protocol(TheBoxUIGridViewDelegate)];

    TheBoxUIGridView* gridView = [[TheBoxUIGridView alloc] init];
    gridView.delegate = mockedDelegate;
    
    [[mockedDelegate expect] gridView:gridView viewOf:view atRow:0 atIndex:0 willAppear:nil];
    
    [gridView viewInScrollView:view willAppear:nil atIndex:0];
    
    [mockedDelegate verify];
}


@end
