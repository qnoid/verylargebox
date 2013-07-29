//
//  NSDictionary+VLBLocation.m
//  verylargebox
//
//  Created by Markos Charatzas on 22/06/2013.
//  Copyright (c) 2013 verylargebox.com. All rights reserved.
//

#import "NSDictionary+VLBLocation.h"

VLBLocationKey const VLBLocationLat = @"lat";
VLBLocationKey const VLBLocationLng = @"lng";
VLBLocationKey const VLBLocationName = @"name";

@implementation NSDictionary (VLBLocation)

-(id)vlb_objectForKey:(VLBLocationKey)key {
    return [self objectForKey:key];
}

-(CLLocationCoordinate2D)vlb_coordinate{
return CLLocationCoordinate2DMake([[self vlb_objectForKey:VLBLocationLat] floatValue], [[self objectForKey:VLBLocationLng] floatValue]);
}
@end
