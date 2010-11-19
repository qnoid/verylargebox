/*
 *  Copyright 2010 The Box
 *  All rights reserved.
 *
 *  This file is part of TheBox
 *
 *  Created by Markos Charatzas <[firstname.lastname@gmail.com]> on 8/11/10.
 *  Contributor(s): .-
 */
#import <UIKit/UIKit.h>
#import "TheBoxScrollView.h"
#import "TheBoxLocationServiceDelegate.h"

@class TheBoxLocationService;

@interface HomeUIViewController : UIViewController <TheBoxLocationServiceDelegate> 
{
	@private
		UILabel *locationLabel;
		UISearchBar *searchBar;
		TheBoxScrollView *theBoxView;
		TheBoxLocationService *theBoxLocationService;
}

@property(nonatomic, assign) IBOutlet UILabel *locationLabel;
@property(nonatomic, assign) IBOutlet UISearchBar *searchBar;
@property(nonatomic, assign) IBOutlet TheBoxScrollView *theBoxView;
@property(nonatomic, retain) TheBoxLocationService *theBoxLocationService;

- (IBAction)upload:(id)sender;
@end
