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
#import "VLBLocationServiceDelegate.h"

/**
 Use this class to retrieve location information such as lat/long and placemarks by a notification.
 
 

 @see #notifyDidUpdateToLocation
 @see #notifyDidFindPlacemark
 */
@interface VLBLocationService : NSObject <CLLocationManagerDelegate>


@property(nonatomic, strong) CLLocationManager *locationManager;

/*
 *
 */
+(VLBLocationService *)theBoxLocationService;

-(id)init:(CLLocationManager *)locationManager;

-(void)startMonitoringSignificantLocationChanges;

-(void)stopMonitoringSignificantLocationChanges;

/*
 * will call didUpdateToLocation:
 * with name "didUpdateToLocation"
 * userInfo @"newLocation"
 */
-(void)notifyDidUpdateToLocation:(id<VLBLocationServiceDelegate>) delegate;

-(void)dontNotifyOnUpdateToLocation:(id<VLBLocationServiceDelegate>) delegate;

/**
 
 will call didFailReverseGeocodeLocationWithError:
 userInfo 
    "error" - NSError
 */
-(void)dontNotifyOnFindPlacemark:(id<VLBLocationServiceDelegate>) delegate;

/*
 * will call didFindPlacemark:
 * with name "didFindPlacemark"
 * userInfo @"place"
 */
-(void)notifyDidFindPlacemark:(id<VLBLocationServiceDelegate>) delegate;

/*
 * will call didFailUpdateToLocationWithError:
 * with name @"didFailWithError"
 * userInfo @"error"
 */
-(void)notifyDidFailWithError:(id<VLBLocationServiceDelegate>) delegate;

-(void)dontNotifyDidFailWithError:(id<VLBLocationServiceDelegate>) delegate;

/*
 * will call didFailReverseGeocodeLocationWithError:
 * with name @"didFailReverseGeocodeLocationWithError"
 * userInfo @"error"
 */
-(void)notifyDidFailReverseGeocodeLocationWithError:(id<VLBLocationServiceDelegate>) delegate;

-(void)dontNotifyDidFailReverseGeocodeLocationWithError:(id<VLBLocationServiceDelegate>) delegate;
@end
