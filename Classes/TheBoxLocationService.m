/*
 *  Copyright 2010 The Box
 *  All rights reserved.
 *
 *  This file is part of TheBox
 *
 *  Created by Markos Charatzas (@qnoid) on 16/11/10.
 *  Contributor(s): .-
 */
#import "TheBoxLocationService.h"

@implementation TheBoxLocationService

+(TheBoxLocationService *) theBox
{
	CLLocationManager *locationManager = [[CLLocationManager alloc] init];
    TheBoxLocationService *theBox = [[TheBoxLocationService alloc] init:locationManager];
    
	locationManager.delegate = theBox;	
	
return theBox;
}

-(void)dealloc
{
    [self.locationManager stopMonitoringSignificantLocationChanges];
}

@synthesize locationManager;

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
	[locationManager startMonitoringSignificantLocationChanges];
}

-(void)dontNotifyOnUpdateToLocation:(id<TheBoxLocationServiceDelegate>) delegate;
{
	NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center removeObserver:delegate name:@"didUpdateToLocation" object:self];
}

-(void)notifyDidFindPlacemark:(id<TheBoxLocationServiceDelegate>) delegate;
{
	NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
	[center addObserver:delegate selector:@selector(didFindPlacemark:) name:@"didFindPlacemark" object:self];
    [locationManager startMonitoringSignificantLocationChanges];
}

-(void)dontNotifyOnFindPlacemark:(id<TheBoxLocationServiceDelegate>) delegate;
{
	NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center removeObserver:delegate name:@"didFindPlacemark" object:self];
}

-(void)notifyDidFailWithError:(id<TheBoxLocationServiceDelegate>) delegate
{
	NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
	[center addObserver:delegate selector:@selector(didFailWithError:) name:@"didFailWithError" object:self];
}

-(void)notifyDidFailReverseGeocodeLocationWithError:(id<TheBoxLocationServiceDelegate>) delegate
{
	[[NSNotificationCenter defaultCenter] addObserver:delegate
                                             selector:@selector(didFailReverseGeocodeLocationWithError:)
                                                 name:@"didFailReverseGeocodeLocationWithError"
                                               object:self];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
	NSDictionary *userInfo = [NSDictionary dictionaryWithObject:newLocation forKey:@"newLocation"]; 
	
	[[NSNotificationCenter defaultCenter] postNotificationName:@"didUpdateToLocation" object:self userInfo:userInfo];
		
    CLGeocoder* geocoder = [CLGeocoder new];
    
    [geocoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *placemarks, NSError *error)
    {
        if(error){
            NSLog(@"Could not retrieve the specified place information.\n");
            
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:error forKey:@"error"];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"didFailReverseGeocodeLocationWithError" object:self userInfo:userInfo];
        return;
        }
     
        CLPlacemark *place = [placemarks objectAtIndex:0];
        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:place forKey:@"place"];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"didFindPlacemark" object:self userInfo:userInfo];
    }];
}

@end
