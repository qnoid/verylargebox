//
//  NSDictionary+VLBLocality.m
//  verylargebox
//
//  Created by Markos Charatzas on 22/06/2013.
//  Copyright (c) 2013 verylargebox.com. All rights reserved.
//

#import "NSDictionary+VLBLocality.h"

NSString* const VLBLocalityName = @"name";

@implementation NSDictionary (VLBLocality)

-(id)vlb_objectForKey:(VLBLocalityKey)key {
    return [self objectForKey:key];
}

@end
