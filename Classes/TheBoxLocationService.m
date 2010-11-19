/*
 *  Copyright 2010 The Box
 *  All rights reserved.
 *
 *  This file is part of TheBox
 *
 *  Created by Markos Charatzas <[firstname.lastname@gmail.com]> on 16/11/10.
 *  Contributor(s): .-
 */
#import "TheBoxLocationService.h"

@implementation TheBoxLocationService

+(TheBoxLocationService *) theBox
{
	CLLocationManager *locationManager = [[CLLocationManager alloc] init];
	TheBoxLocationService *theBox = [[TheBoxLocationService alloc] init:locationManager];
	[locationManager release];

	locationManager.delegate = theBox;
	locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
	
	// Set a movement threshold for new events.
	locationManager.distanceFilter = 500;
	
	[locationManager startUpdatingLocation];		
	
	
return theBox;
}

@synthesize locationManager;
@synthesize theGeocoder;

- (void) dealloc
{
	[locationManager release];
	[theGeocoder release];
	[super dealloc];
}

-(id)init:(CLLocationManager *)aLocationManager
{
	self = [super init];
	
	if (self) 
	{
		self.locationManager = aLocationManager;
	}
	
return self;
}

-(void)notifyDidUpdateToLocation:(id<TheBoxLocationServiceDelegate>) delegate;
{
	NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
	[center addObserver:delegate selector:@selector(didUpdateToLocation:) name:@"didUpdateToLocation" object:self];
}

-(void)notifyDidFindPlacemark:(id<TheBoxLocationServiceDelegate>) delegate;
{
	NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
	[center addObserver:delegate selector:@selector(didFindPlacemark:) name:@"didFindPlacemark" object:self];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
	NSDictionary *userInfo = [NSDictionary dictionaryWithObject:newLocation forKey:@"newLocation"]; 
	
	NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
	[center postNotificationName:@"didUpdateToLocation" object:self userInfo:userInfo];
		
	self.theGeocoder = [[MKReverseGeocoder alloc] initWithCoordinate:newLocation.coordinate];
	
    theGeocoder.delegate = self;
    [theGeocoder start];
}

// Delegate methods
- (void)reverseGeocoder:(MKReverseGeocoder*)geocoder didFindPlacemark:(MKPlacemark*)place
{
	NSDictionary *userInfo = [NSDictionary dictionaryWithObject:place forKey:@"place"]; 
	
	NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
	[center postNotificationName:@"didFindPlacemark" object:self userInfo:userInfo];
}

- (void)reverseGeocoder:(MKReverseGeocoder*)geocoder didFailWithError:(NSError*)error
{
    NSLog(@"Could not retrieve the specified place information.\n");
}

@end
