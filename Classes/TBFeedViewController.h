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

 If it fails to reverse geocode to select one of the localities where thebox is available. (as returned by the server)
 
 Will prompt the user to select a locality (even outside his current one)
 */
@interface TBFeedViewController : UIViewController <TheBoxUIScrollViewDatasource, TheBoxUIScrollViewDelegate, TBItemsOperationDelegate, TheBoxLocationServiceDelegate, TBLocalitiesTableViewControllerDelegate>

+(TBFeedViewController *)newFeedViewController;

@end
