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

@implementation WelcomeUIViewController

@synthesize locationLabel;
@synthesize checkInButton;
@synthesize theBoxLocationService;

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
	CLLocationDegrees latitude = place.coordinate.latitude;
	CLLocationDegrees longitude = place.coordinate.longitude;
	
	NSLog(@"latitude %f", latitude);
	NSLog(@"longitude %f", longitude);
	
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
    HomeUIGridViewController *homeGridViewController = [HomeUIGridViewController newHomeGridViewController];

    UINavigationController* navigationController = [[UINavigationController alloc] initWithRootViewController:homeGridViewController];
    [self presentModalViewController:navigationController animated:YES];	
}

@end
