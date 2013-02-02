/*
 *  Copyright 2010 The Box
 *  All rights reserved.
 *
 *  This file is part of TheBox
 *
 *  Created by Markos Charatzas (@qnoid) on 16/11/10.
 *  Contributor(s): .-
 */
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "TheBoxLocationServiceDelegate.h"

@interface TheBoxLocationService : NSObject <CLLocationManagerDelegate>
{
}

@property(nonatomic, strong) CLLocationManager *locationManager;

/*
 *
 */
+(TheBoxLocationService *) theBox;

-(id)init:(CLLocationManager *)locationManager;

/*
 * will call didUpdateToLocation:
 * with name "didUpdateToLocation"
 * userInfo @"newLocation"
 */
-(void)notifyDidUpdateToLocation:(id<TheBoxLocationServiceDelegate>) delegate;

-(void)dontNotifyOnUpdateToLocation:(id<TheBoxLocationServiceDelegate>) delegate;

/**
 
 will call didFailReverseGeocodeLocationWithError:
 userInfo 
    "error" - NSError
 */
-(void)dontNotifyOnFindPlacemark:(id<TheBoxLocationServiceDelegate>) delegate;

/*
 * will call didFindPlacemark:
 * with name "didFindPlacemark"
 * userInfo @"place"
 */
-(void)notifyDidFindPlacemark:(id<TheBoxLocationServiceDelegate>) delegate;

/*
 * will call didFailWithError:
 * with name @"didFailWithError"
 * userInfo @"error"
 */
-(void)notifyDidFailWithError:(id<TheBoxLocationServiceDelegate>) delegate;

/*
 * will call didFailReverseGeocodeLocationWithError:
 * with name @"didFailReverseGeocodeLocationWithError"
 * userInfo @"error"
 */
-(void)notifyDidFailReverseGeocodeLocationWithError:(id<TheBoxLocationServiceDelegate>) delegate;
@end
