/*
 *  Copyright 2010 The Box
 *  All rights reserved.
 *
 *  This file is part of TheBox
 *
 *  Created by Markos Charatzas <[firstname.lastname@gmail.com]> on 8/11/10.
 *  Contributor(s): .-
 */
#import "WelcomeUIViewController.h"

@implementation WelcomeUIViewController

@synthesize locationLabel;
@synthesize checkInButton;


+(WelcomeUIViewController*)newWelcomeViewController {
    return [[WelcomeUIViewController alloc] initWithNibName:@"WelcomeUIViewController" bundle:[NSBundle mainBundle]];
}

- (IBAction)enter:(id)sender 
{
	NSLog(@"Hello %@", locationLabel.text);
    HomeUIGridViewController *homeGridViewController = [HomeUIGridViewController newHomeGridViewController];

    UINavigationController* navigationController = [[UINavigationController alloc] initWithRootViewController:homeGridViewController];
    [self presentModalViewController:navigationController animated:YES];	
}

@end
