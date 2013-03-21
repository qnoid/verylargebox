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
@class TheBoxLocationService;

/**
 Displays available stores based on the user location.
 
 If it fails to obtain the user location, the user will be prompted to select one of the locations where thebox is available. (as returned by the server)
 
  Item cells are recycled, as a result setting the image to a recycled cell will cancel an existing request to load the last visible image
  and start a new one.
 */
@interface HomeUIGridViewController : UIViewController <TheBoxLocationServiceDelegate, TheBoxUIScrollViewDatasource, TheBoxUIScrollViewDelegate, TBLocationOperationDelegate, UISearchBarDelegate, TBItemsOperationDelegate, UITableViewDataSource, UITableViewDelegate, TheBoxLocationServiceDelegate, UITableViewDelegate, TheBoxUIGridViewDatasource, TheBoxUIGridViewDelegate>
{
    
}

+(HomeUIGridViewController*)newHomeGridViewController;

@property(nonatomic, strong) IBOutlet UIButton* directionsButton;
@property(nonatomic, strong) IBOutlet UIImageView* signPostImageView;
@property(nonatomic, strong) IBOutlet TheBoxUIScrollView* locationsView;
@property(nonatomic, strong) IBOutlet TheBoxUIGridView* itemsView;

@end
