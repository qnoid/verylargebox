//
//  Copyright 2010 The Box
//  All rights reserved.
//
//  This file is part of TheBox
//
//  Created by Markos Charatzas on 16/11/10.
//
//

#import "VLBLocationService.h"
#import "DDLog.h"

VLBLocationServiceDirections const VLBLocationServiceDirectionsNone = ^{};

@implementation VLBLocationService

+(VLBLocationService *)theBoxLocationService
{
	CLLocationManager *locationManager = [[CLLocationManager alloc] init];
    locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers;
    locationManager.distanceFilter = 3000.0;
    VLBLocationService *theBox = [[VLBLocationService alloc] init:locationManager];
    
	locationManager.delegate = theBox;	
	
return theBox;
}

+(VLBLocationServiceDirections) directionsWithAppleMaps:(CLLocationCoordinate2D) destination options:(NSDictionary*) options
{
    return ^(){
        MKPlacemark* placeMark = [[MKPlacemark alloc] initWithCoordinate:destination addressDictionary:nil];
        
        MKMapItem* mapItem =  [[MKMapItem alloc] initWithPlacemark:placeMark];
        
        id name = [options objectForKey:@"name"];
        if([[NSNull null] isEqual:name]){
            name = @"";
        }
        
        mapItem.name = name;
        [mapItem openInMapsWithLaunchOptions:@{MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeWalking}];
    };
}

+(VLBLocationServiceDirections) directionsWithGoogleMaps:(CLLocationCoordinate2D) destination options:(NSDictionary*) options
{
    return ^(){
        NSString *urlstring =
        [NSString stringWithFormat:@"http://maps.google.com/?dirflg=w&daddr=%f,%f",
         destination.latitude,
         destination.longitude];
        
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:urlstring]];
    };
}

+(VLBLocationServiceDirections) decideOnDirections:(CLLocationCoordinate2D) destination options:(NSDictionary*) options
{
    Class itemClass = [MKMapItem class];
    if ([itemClass respondsToSelector:@selector(openMapsWithItems:launchOptions:)]) {
        return [self directionsWithAppleMaps:destination options:options];
    }
    
    return [self directionsWithGoogleMaps:destination options:options];
}


-(void)dealloc
{
    [self.locationManager stopUpdatingLocation];
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

//http://stackoverflow.com/questions/16875559/does-cllocationmanagerstartmonitoringsignificantlocationchanges-prompt-for-user
-(void)startMonitoringSignificantLocationChanges {
    [self.locationManager startUpdatingLocation];
}

-(void)stopMonitoringSignificantLocationChanges {
    [self.locationManager stopUpdatingLocation];
}

-(void)notifyDidUpdateToLocation:(id<VLBLocationServiceDelegate>) delegate;
{
	NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
	[center addObserver:delegate selector:@selector(didUpdateToLocation:) name:@"didUpdateToLocation" object:self];
}

-(void)dontNotifyOnUpdateToLocation:(id<VLBLocationServiceDelegate>) delegate;
{
	NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center removeObserver:delegate name:@"didUpdateToLocation" object:self];
}

-(void)notifyDidFindPlacemark:(id<VLBLocationServiceDelegate>) delegate;
{
	NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
	[center addObserver:delegate selector:@selector(didFindPlacemark:) name:@"didFindPlacemark" object:self];
}

-(void)dontNotifyOnFindPlacemark:(id<VLBLocationServiceDelegate>) delegate;
{
	NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center removeObserver:delegate name:@"didFindPlacemark" object:self];
}

-(void)notifyDidFailWithError:(id<VLBLocationServiceDelegate>) delegate
{
	NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:delegate selector:@selector(didFailUpdateToLocationWithError:) name:@"didFailWithError" object:self];
}

-(void)dontNotifyDidFailWithError:(id<VLBLocationServiceDelegate>) delegate
{
	NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center removeObserver:delegate name:@"didFailWithError" object:self];
}

-(void)notifyDidFailReverseGeocodeLocationWithError:(id<VLBLocationServiceDelegate>) delegate
{
	[[NSNotificationCenter defaultCenter] addObserver:delegate
                                             selector:@selector(didFailReverseGeocodeLocationWithError:)
                                                 name:@"didFailReverseGeocodeLocationWithError"
                                               object:self];
}

-(void)dontNotifyDidFailReverseGeocodeLocationWithError:(id<VLBLocationServiceDelegate>) delegate
{
	[[NSNotificationCenter defaultCenter] removeObserver:delegate
                                                 name:@"didFailReverseGeocodeLocationWithError"
                                               object:self];
}


- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    DDLogVerbose(@"%s", __PRETTY_FUNCTION__);

	NSDictionary *userInfo = [NSDictionary dictionaryWithObject:newLocation forKey:@"newLocation"];
	
	[[NSNotificationCenter defaultCenter] postNotificationName:@"didUpdateToLocation" object:self userInfo:userInfo];
		
    CLGeocoder* geocoder = [CLGeocoder new];
    
    [geocoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *placemarks, NSError *error)
    {

        //if place is nil, if the request was canceled
        if(error){
            DDLogError(@"Could not retrieve the specified place information.\n");
            
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:error forKey:@"error"];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"didFailReverseGeocodeLocationWithError" object:self userInfo:userInfo];
        return;
        }
     
        CLPlacemark *place = [placemarks objectAtIndex:0];

        if(!place || !place.locality){
		
            NSError *error = [NSError errorWithDomain:kCLErrorDomain code:kCLErrorGeocodeFoundNoResult userInfo:nil];

            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:error forKey:@"error"];
            
         	[[NSNotificationCenter defaultCenter] postNotificationName:@"didFailReverseGeocodeLocationWithError"
                                                                object:self
                                                              userInfo:userInfo];
        return;
		}

        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:place forKey:@"place"];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"didFindPlacemark" object:self userInfo:userInfo];
    }];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    DDLogError(@"%s %@", __PRETTY_FUNCTION__, error);
    
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:error forKey:@"error"];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"didFailWithError" object:self userInfo:userInfo];
}

@end
