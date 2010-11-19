/*
 *  Copyright 2010 The Box
 *  All rights reserved.
 *
 *  This file is part of TheBox
 *
 *  Created by Markos Charatzas <[firstname.lastname@gmail.com]> on 16/11/10.
 *  Contributor(s): .-
 */
#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "TheBoxLocationServiceDelegate.h"

@interface TheBoxLocationService : NSObject <CLLocationManagerDelegate, MKReverseGeocoderDelegate>
{
	@private
		CLLocationManager *locationManager;
		MKReverseGeocoder* theGeocoder;
}

@property(nonatomic, retain) CLLocationManager *locationManager;
@property(nonatomic, retain) MKReverseGeocoder *theGeocoder;

/*
 *
 */
+(TheBoxLocationService *) theBox;

-(id)init:(CLLocationManager *)locationManager;

/*
 * will call didUpdateToLocation:
 * with name "didUpdateToLocation"
 */
-(void)notifyDidUpdateToLocation:(id<TheBoxLocationServiceDelegate>) delegate;

/*
 * will call didFindPlacemark:
 * with name "didFindPlacemark"
 */
-(void)notifyDidFindPlacemark:(id<TheBoxLocationServiceDelegate>) delegate;


@end
