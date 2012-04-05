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
#import <Foundation/Foundation.h>
#import "TheBoxLocationServiceDelegate.h"
#import "HomeUIGridViewController.h"

@class TheBoxLocationService;

@interface WelcomeUIViewController : UIViewController <TheBoxLocationServiceDelegate> 
{
	@private
		TheBoxLocationService *theBoxLocationService;
		HomeUIGridViewController *gridViewController;
}

@property(nonatomic, assign) IBOutlet UILabel *locationLabel;
@property(nonatomic, assign) IBOutlet UIButton *checkInButton;
@property(nonatomic, retain) IBOutlet HomeUIGridViewController *gridViewController;
@property(nonatomic, retain) TheBoxLocationService *theBoxLocationService;

- (IBAction)enter:(id)sender;
@end
