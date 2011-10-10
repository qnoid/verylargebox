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
#import "TheBox.h"
#import "TheBoxDataParserDelegate.h"
#import "TheBoxResponseParserDelegate.h"
@class TheBoxLocationService;
@class TheBoxUIGridView;

@interface HomeUIGridViewController : TheBoxUIGridViewController <TheBoxLocationServiceDelegate, UISearchBarDelegate, TheBoxDelegate, TheBoxResponseParserDelegate, TheBoxDataParserDelegate> 
{
	@private
		UILabel *locationLabel;
		TheBoxLocationService *theBoxLocationService;	
		NSMutableArray *items;
		TheBox *theBox;
		NSCache* imageCache;
}

@property(nonatomic, retain) IBOutlet UILabel *locationLabel;
@property(nonatomic, retain) TheBoxLocationService *theBoxLocationService;
@property(nonatomic, retain) NSMutableArray *items;
@property(nonatomic, retain) TheBox *theBox;
@property(nonatomic, retain) NSCache *imageCache;

- (IBAction)upload:(id)sender;

@end
