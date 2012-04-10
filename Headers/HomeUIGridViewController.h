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
#import "TBCategoriesOperationDelegate.h"
#import "TBCreateItemOperationDelegate.h"
@class TheBoxLocationService;
@class TheBoxUIGridView;

@interface HomeUIGridViewController : TheBoxUIGridViewController <TheBoxLocationServiceDelegate, UISearchBarDelegate, TBCategoriesOperationDelegate, TBCreateItemOperationDelegate> 
{
}

@property(nonatomic, unsafe_unretained) IBOutlet UILabel *locationLabel;

+(HomeUIGridViewController*)newHomeGridViewController;

- (IBAction)upload:(id)sender;

@end
