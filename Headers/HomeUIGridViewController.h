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
@class TheBoxLocationService;

/**
 
 
  Categories must be sorted by id since the item lookup on the response of POST /items does a binary search to find the category the item was created. 
  Item cells are recycled, as a result setting the image to a recycled cell will cancel an existing request to load the last visible image
  and start a new one.
 */
@interface HomeUIGridViewController : UIViewController <TheBoxLocationServiceDelegate, TheBoxUIScrollViewDatasource, TheBoxUIScrollViewDelegate, TBLocationOperationDelegate, UISearchBarDelegate, TBItemsOperationDelegate, UITableViewDataSource, UITableViewDelegate, TheBoxLocationServiceDelegate>
{
    
}

+(HomeUIGridViewController*)newHomeGridViewController;

@property(nonatomic, strong) IBOutlet UIButton* directionsButton;
@property(nonatomic, strong) IBOutlet UIImageView* signPostImageView;
@property(nonatomic, strong) IBOutlet TheBoxUIScrollView* locationsView;
@property(nonatomic, strong) IBOutlet TheBoxUIScrollView* itemsView;

@end
