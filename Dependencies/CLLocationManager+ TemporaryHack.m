//
//  CLLocationManager+ TemporaryHack.m
//  TheBox
//
//  Created by Markos Charatzas on 20/08/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CLLocationManager+ TemporaryHack.h"

@implementation CLLocationManager (TemporaryHack)

- (void)hackLocationFix
{
    CLLocation *location = [[CLLocation alloc] initWithLatitude:42 longitude:-50];
    [[self delegate] locationManager:self didUpdateToLocation:location fromLocation:nil];     
}

- (void)startUpdatingLocation
{
    [self performSelector:@selector(hackLocationFix) withObject:nil afterDelay:0.1];
}

@end