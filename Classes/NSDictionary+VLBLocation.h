//
//  NSDictionary+VLBLocation.h
//  verylargebox
//
//  Created by Markos Charatzas on 22/06/2013.
//  Copyright (c) 2013 verylargebox.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

#define VLBLocationKey NSString*

extern VLBLocationKey const VLBLocationLat;
extern VLBLocationKey const VLBLocationLng;
extern VLBLocationKey const VLBLocationName;

@interface NSDictionary (VLBLocation)

-(id)vlb_objectForKey:(VLBLocationKey)key;
-(CLLocationCoordinate2D)vlb_coordinate;

@end
