//
//  NSDictionary+VLBLocation.m
//  thebox
//
//  Created by Markos Charatzas on 22/06/2013.
//  Copyright (c) 2013 verylargebox.com. All rights reserved.
//

#import "NSDictionary+VLBLocation.h"

NSString* const VLBLocationLat = @"lat";
NSString* const VLBLocationLng = @"lng";
NSString* const VLBLocationName = @"name";

@implementation NSDictionary (VLBLocation)

-(id)vlb_objectForKey:(VLBLocationKey)key {
    return [self objectForKey:key];
}

@end
