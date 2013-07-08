//
//  VLBFeedViewController.h
//  verylargebox
//
//  Created by Markos Charatzas on 25/05/2013.
//  Copyright (c) 2013 (verylargebox.com). All rights reserved.
//

#import "VLBScrollView.h"
#import "VLBItemsOperationDelegate.h"
#import "VLBLocationServiceDelegate.h"
#import "VLBLocalitiesTableViewController.h"

/**
 Displays a scroll view of VLBUserItemView(s) based on the user's locality.
 
 #events
    didFindPlacemark
        1. will async get the first page of items under the resolved locality
        2. will async get all the items under the resolved locality
 
    didFailReverseGeocodeLocationWithError
        will prompt the user to select a locality as returned by the server (even outside his actual one)
 
    didSelectLocality (via didFailReverseGeocodeLocationWithError)
        1. will queue a get for the first page of items under the resolved locality
        2. will queue a get for all the items under the resolved locality
 
 #network connections
        one at a time to verylargebox.com (2 in total for paging)
 
 #considerations
    The controller will always issue a second request to fetch all the items from the server, even if the first page
    returned every item available.
    will refresh the items on appear (might want to throttle)
   
 @see VLBScrollView
 @see VLBQueries#newGetItems:delegate
 @see VLBQueries#newGetItems:page:delegate
 @see VLBQueries#newGetLocalities:
 */
@interface VLBFeedViewController : UIViewController <VLBScrollViewDatasource, VLBScrollViewDelegate, VLBItemsOperationDelegate, VLBLocationServiceDelegate, VLBLocalitiesTableViewControllerDelegate>

@property(nonatomic, weak) IBOutlet VLBScrollView * feedView;

+(VLBFeedViewController *)newFeedViewController;

@end
