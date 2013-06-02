//
//  HomeUIGridViewControllerTest.m
//  thebox
//
//  Created by Markos Charatzas on 02/06/2013.
//  Copyright (c) 2013 TheBox. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import <OCMock/OCMock.h>
#import "HomeUIGridViewController.h"

@interface HomeUIGridViewController (Testing)
-(void)reloadItems;
@end

@interface HomeUIGridViewControllerTest : SenTestCase

@end

@implementation HomeUIGridViewControllerTest

-(void)testGivenScrollViewWillStopAtOnDoubleTapAssertReloadItemsOnce

{
    HomeUIGridViewController *viewController = [[HomeUIGridViewController alloc] init];
    id mockLocationsView = [OCMockObject niceMockForClass:[TheBoxUIScrollView class]];
    id mockItemsView = [OCMockObject niceMockForClass:[TheBoxUIGridView class]];
    viewController.locationsView = mockLocationsView;
    viewController.itemsView = mockItemsView;
    
    id mockViewController = [OCMockObject partialMockForObject:viewController];

    [[mockViewController expect] reloadItems];
    
    [mockViewController scrollView:mockLocationsView willStopAt:1];
    [mockViewController scrollView:mockLocationsView willStopAt:1];
    
    [mockViewController verify];

}
@end
