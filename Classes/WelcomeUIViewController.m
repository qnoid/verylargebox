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
#import "TheBoxNotifications.h"
#import "TheBoxLocationService.h"
#import "HomeUIGridViewController.h"

@implementation WelcomeUIViewController

@synthesize welcomeLabel;
@synthesize toLabel;
@synthesize locationLabel;
@synthesize checkInButton;
@synthesize theBoxLocationService;

- (void) dealloc
{
	[theBoxLocationService release];
	[super dealloc];
}

-(void) viewDidLoad
{
	self.theBoxLocationService = [TheBoxLocationService theBox];
	[self.theBoxLocationService notifyDidFindPlacemark:self];
	[self.theBoxLocationService notifyDidFailWithError:self];	
}

-(void)didFindPlacemark:(NSNotification *)notification;
{
	MKPlacemark *place = [TheBoxNotifications place:notification];
	NSString *city = place.locality;
	
	NSLog(@"city: %@", city);
	locationLabel.text = city;	
	locationLabel.hidden = NO;
	checkInButton.hidden = NO;
	checkInButton.enabled = YES;
}

-(void)didFailWithError:(NSNotification *)notification
{
	NSError *error = [TheBoxNotifications error:notification];
	
	NSLog(@"%@", error);
	
	locationLabel.text = @"Unknown";
	locationLabel.hidden = NO;
	checkInButton.hidden = NO;
	checkInButton.enabled = YES;
}


- (IBAction)enter:(id)sender 
{
	NSLog(@"Hello %@", locationLabel.text);
	
	NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"Home" owner:self options:nil];	
	UIViewController *home = [views objectAtIndex:0];
	
	[self presentModalViewController:home animated:YES];
	
	[home release];
}

@end
