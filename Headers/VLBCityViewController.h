//
//
//  VLBCityViewController.h
//  verylargebox
//
//  Created by Markos Charatzas on 23/11/2010.
//  Copyright (c) 2010 (verylargebox.com). All rights reserved.
//
#import "VLBGridViewController.h"
#import "VLBLocationServiceDelegate.h"
#import "VLBItemsOperationDelegate.h"
#import "VLBLocationOperationDelegate.h"
#import "VLBScrollView.h"
#import "VLBScrollViewDatasource.h"
#import "VLBGridViewDatasource.h"
#import "VLBGridViewDelegate.h"
#import "VLBLocalityOperationDelegate.h"
#import "VLBViews.h"
#import "VLBView.h"
@class VLBLocationService;

/**
 Displays available stores based on the user location.
 
 A navigation button to refresh the locations given the user locality is disabled until a user location is obtained.
 
 If it fails to obtain the user location, the user will be prompted to enable location services.
 
 If it fails to reverse geocode to select one of the localities where thebox is available. (as returned by the server)
 
 Will prompt the user to select a locality (even outside his current one)
 
 VLBItem cells are recycled, as a result setting the image to a recycled cell will cancel an existing request to load the last visible image
  and start a new one.
 
 Decisions
    The grid view does not bounce so as not to confuse the user with the missing pull to refresh
 
 */
@interface VLBCityViewController : UIViewController <VLBLocationServiceDelegate, VLBScrollViewDatasource, VLBScrollViewDelegate, VLBLocationOperationDelegate, UISearchBarDelegate, VLBItemsOperationDelegate, VLBLocationServiceDelegate, UITableViewDelegate, VLBGridViewDatasource, VLBGridViewDelegate, VLBViewDrawRectDelegate>

/**
 Creates a new instance of HomeUIGridViewController
 */
+(VLBCityViewController *)newHomeGridViewController;

@property(nonatomic, weak) IBOutlet UIButton* directionsButton;
@property(nonatomic, strong) IBOutlet VLBScrollView * locationsView;
@property(nonatomic, strong) IBOutlet VLBGridView * itemsView;

-(IBAction)didTapOnGetDirectionsButton:(id)sender;

@end
