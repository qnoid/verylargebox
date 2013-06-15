//
//  TBFeedViewController.h
//  thebox
//
//  Created by Markos Charatzas on 25/05/2013.
//  Copyright (c) 2013 TheBox. All rights reserved.
//

#import "TheBoxUIScrollView.h"
#import "TBItemsOperationDelegate.h"
#import "TheBoxLocationServiceDelegate.h"
#import "TBLocalitiesTableViewController.h"

/**
 Displays a scroll view of TBUserItemView(s) based on the user's locality.
 
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
        one at a time to verylargebox.com
 
 #considerations
    The controller will always issue a second request to fetch all the items from the server, even if the first page
    returned every item available.
   
 @see TheBoxUIScrollView
 @see TheBoxQueries#newGetItems:delegate 
 @see TheBoxQueries#newGetItems:page:delegate
 @see TheBoxQueries#newGetLocalities:
 */
@interface TBFeedViewController : UIViewController <TheBoxUIScrollViewDatasource, TheBoxUIScrollViewDelegate, TBItemsOperationDelegate, TheBoxLocationServiceDelegate, TBLocalitiesTableViewControllerDelegate>

+(TBFeedViewController *)newFeedViewController;

@end
