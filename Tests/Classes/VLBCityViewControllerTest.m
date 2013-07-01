//
//  HomeUIGridViewControllerTest.m
//  verylargebox
//
//  Created by Markos Charatzas on 02/06/2013.
//  Copyright (c) 2013 (verylargebox.com). All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import <OCMock/OCMock.h>
#import "VLBCityViewController.h"

@interface VLBCityViewController (Testing)
-(void)reloadItems;
@end

@interface VLBCityViewControllerTest : SenTestCase

@end

@implementation VLBCityViewControllerTest

-(void)testGivenScrollViewWillStopAtOnDoubleTapAssertReloadItemsOnce

{
    VLBCityViewController *viewController = [[VLBCityViewController alloc] init];
    id mockLocationsView = [OCMockObject niceMockForClass:[VLBScrollView class]];
    id mockItemsView = [OCMockObject niceMockForClass:[VLBGridView class]];
    viewController.locationsView = mockLocationsView;
    viewController.itemsView = mockItemsView;
    
    id mockViewController = [OCMockObject partialMockForObject:viewController];

    [[mockViewController expect] reloadItems];
    
    [mockViewController scrollView:mockLocationsView willStopAt:1];
    [mockViewController scrollView:mockLocationsView willStopAt:1];
    
    [mockViewController verify];

}
@end
