/*
 *  Copyright 2010 The Box
 *  All rights reserved.
 *
 *  This file is part of TheBox
 *
 *  Created by Markos Charatzas <[firstname.lastname@gmail.com]> on 8/11/10.
 *  Contributor(s): .-
 */
#import "HomeUIViewController.h"
#import "TheBoxLocationService.h"
#import "TheBoxNotifications.h"

@implementation HomeUIViewController

@synthesize locationLabel;
@synthesize searchBar;
@synthesize theBoxView;

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
	
}

- (IBAction)upload:(id)sender 
{
	NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"Upload" owner:self options:nil];
	
	UIViewController *upload = [views objectAtIndex:0];

	[self presentModalViewController:upload animated:YES];    
}

-(void)didFindPlacemark:(NSNotification *)notification;
{
	MKPlacemark *place = [TheBoxNotifications place:notification];
	NSString *city = place.locality;
	
	locationLabel.text = city;		
	locationLabel.hidden = NO;	
}

@end
