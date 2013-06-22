//
//  NSDictionary+VLBLocation.h
//  thebox
//
//  Created by Markos Charatzas on 22/06/2013.
//  Copyright (c) 2013 verylargebox.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#define VLBLocationKey NSString*

extern VLBLocationKey const VLBLocationLat;
extern VLBLocationKey const VLBLocationLng;
extern VLBLocationKey const VLBLocationName;

@interface NSDictionary (VLBLocation)

-(id)vlb_objectForKey:(VLBLocationKey)key;

@end
