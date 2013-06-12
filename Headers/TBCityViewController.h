/*
 *  Copyright 2010 The Box
 *  All rights reserved.
 *
 *  This file is part of TheBox
 *
 *  Created by Markos Charatzas (@qnoid) on 23/11/10.
 *  Contributor(s): .-
 */
#import "TheBoxUIGridViewController.h"
#import "TheBoxLocationServiceDelegate.h"
#import "TBItemsOperationDelegate.h"
#import "TBLocationOperationDelegate.h"
#import "TheBoxUIScrollView.h"
#import "TheBoxUIScrollViewDatasource.h"
#import "TheBoxUIGridViewDatasource.h"
#import "TheBoxUIGridViewDelegate.h"
#import "TBLocalityOperationDelegate.h"
#import "TBLocalitiesTableViewController.h"
#import "TBViews.h"
#import "TBView.h"
@class TheBoxLocationService;

/**
 Displays available stores based on the user location.
 
 A navigation button to refresh the locations given the user locality is disabled until a user location is obtained.
 
 If it fails to obtain the user location, the user will be prompted to enable location services.
 
 If it fails to reverse geocode to select one of the localities where thebox is available. (as returned by the server)
 
 Will prompt the user to select a locality (even outside his current one)
 
 Item cells are recycled, as a result setting the image to a recycled cell will cancel an existing request to load the last visible image
  and start a new one.
 
 */
@interface TBCityViewController : UIViewController <TheBoxLocationServiceDelegate, TheBoxUIScrollViewDatasource, TheBoxUIScrollViewDelegate, TBLocationOperationDelegate, UISearchBarDelegate, TBItemsOperationDelegate, TheBoxLocationServiceDelegate, UITableViewDelegate, TheBoxUIGridViewDatasource, TheBoxUIGridViewDelegate, TBLocalitiesTableViewControllerDelegate, TBViewDrawRectDelegate>

/**
 Creates a new instance of HomeUIGridViewController
 */
+(TBCityViewController*)newHomeGridViewController;

@property(nonatomic, strong) IBOutlet UIButton* directionsButton;
@property(nonatomic, strong) IBOutlet TheBoxUIScrollView* locationsView;
@property(nonatomic, strong) IBOutlet TheBoxUIGridView* itemsView;

@end
