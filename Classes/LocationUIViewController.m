/*
 *  Copyright 2010 The Box
 *  All rights reserved.
 *
 *  This file is part of TheBox
 *
 *  Created by Markos Charatzas <[firstname.lastname@gmail.com]> on 15/11/10.
 *  Contributor(s): .-
 */
#import "LocationUIViewController.h"
#import "TheBoxLocationService.h"
#import "TheBoxNotifications.h"

@implementation LocationUIViewController

@synthesize locationTextField;
@synthesize map;
@synthesize theBoxLocationService;

- (void) dealloc
{
	[theBoxLocationService release];
	[super dealloc];
}


-(void) viewDidLoad
{
	self.theBoxLocationService = [TheBoxLocationService theBox];
	[self.theBoxLocationService notifyDidUpdateToLocation:self];
	[self.theBoxLocationService notifyDidFindPlacemark:self];	
}

- (IBAction)done:(id)sender
{
	NSDictionary *userInfo = [NSDictionary dictionaryWithObject:locationTextField.text forKey:@"location"]; 

	NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
	
	[center postNotificationName:@"didEnterLocation" object:self userInfo:userInfo];

	[self dismissModalViewControllerAnimated:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	[textField resignFirstResponder];
	[self done:self];
return YES;	
}

-(void)didUpdateToLocation:(NSNotification *)notification;
{
	CLLocation *location = [TheBoxNotifications location:notification];
	
	CLLocationCoordinate2D centerCoordinate = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude) ;
	MKCoordinateSpan span = MKCoordinateSpanMake(0.009, 0.009);
	MKCoordinateRegion newRegion = MKCoordinateRegionMake(centerCoordinate, span);	

	[map setRegion:newRegion];
}
-(void)didFindPlacemark:(NSNotification *)notification
{
	MKPlacemark *place = [TheBoxNotifications place:notification];

	[map addAnnotation:place];
}

@end
