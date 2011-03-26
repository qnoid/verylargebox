/*
 *  Copyright 2010 The Box
 *  All rights reserved.
 *
 *  This file is part of TheBox
 *
 *  Created by Markos Charatzas <[firstname.lastname@gmail.com]> on 23/11/10.
 *  Contributor(s): .-
 */
#import <UIKit/UIKit.h>
#import "TheBoxUIGridViewController.h"
#import "TheBoxLocationServiceDelegate.h"
#import "UploadUIViewController.h"
#import "TheBox.h"
@class TheBoxLocationService;
@class TheBoxUIGridView;

@interface HomeUIGridViewController : TheBoxUIGridViewController <TheBoxLocationServiceDelegate, UISearchBarDelegate, TheBoxDelegate> 
{
	@private
		UploadUIViewController *uploadViewController;
		UILabel *locationLabel;
		UISearchBar *searchBar;
		TheBoxLocationService *theBoxLocationService;	
		NSArray *items;

}

@property(nonatomic, retain) IBOutlet UploadUIViewController *uploadViewController;
@property(nonatomic, retain) IBOutlet UILabel *locationLabel;
@property(nonatomic, retain) IBOutlet UISearchBar *searchBar;
@property(nonatomic, retain) TheBoxLocationService *theBoxLocationService;
@property(nonatomic, retain) NSArray *items;

- (IBAction)upload:(id)sender;

@end
