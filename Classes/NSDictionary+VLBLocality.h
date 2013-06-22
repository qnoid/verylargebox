//
//  NSDictionary+VLBLocality.h
//  thebox
//
//  Created by Markos Charatzas on 22/06/2013.
//  Copyright (c) 2013 verylargebox.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#define VLBLocalityKey NSString*

extern VLBLocalityKey const VLBLocalityName;

@interface NSDictionary (VLBLocality)

-(id)vlb_objectForKey:(VLBLocalityKey)key;

@end
