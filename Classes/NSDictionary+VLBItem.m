//
//  NSDictionary+VLBItem.m
//  thebox
//
//  Created by Markos Charatzas on 22/06/2013.
//  Copyright (c) 2013 verylargebox.com. All rights reserved.
//

#import "NSDictionary+VLBItem.h"

NSString* const VLBItemLocation = @"location";
NSString* const VLBItemWhen = @"when";
NSString* const VLBItemIPhoneImageURL = @"iphoneImageURL";
NSString* const VLBItemLocality = @"locality";

@implementation NSDictionary (VLBItem)

-(NSDictionary*)vlb_locality {
    return [self objectForKey:VLBItemLocality];
}

-(NSDictionary*)vlb_location {
    return [self objectForKey:VLBItemLocation];
}

-(id)vlb_objectForKey:(VLBItemKey)key {
    return [self objectForKey:key];
}

@end
