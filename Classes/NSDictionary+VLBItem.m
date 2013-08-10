//
//  NSDictionary+VLBItem.m
//  verylargebox
//
//  Created by Markos Charatzas on 22/06/2013.
//  Copyright (c) 2013 verylargebox.com. All rights reserved.
//

#import "NSDictionary+VLBItem.h"
#import "TTTTimeIntervalFormatter.h"

VLBItemKey const VLBItemId = @"id";
VLBItemKey const VLBItemLocation = @"location";
VLBItemKey const VLBItemWhen = @"when";
VLBItemKey const VLBItemImageURL = @"imageURL";
VLBItemKey const VLBItemIPhoneImageURL = @"iphoneImageURL";
VLBItemKey const VLBItemLocality = @"locality";
VLBItemKey const VLBItemImageKey = @"image_file_name";
VLBItemKey const VLBItemCreatedAtKey = @"created_at";
VLBItemKey const VLBItemTimeIntervalSinceNowKey = @"timeIntervalSinceNow";

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

-(NSInteger)vlb_timeIntervalSinceNow{
    return [[self vlb_objectForKey:VLBItemTimeIntervalSinceNowKey] integerValue];
}

-(NSString*)vlb_when
{
    TTTTimeIntervalFormatter *timeIntervalFormatter = [[TTTTimeIntervalFormatter alloc] init];
return [timeIntervalFormatter stringForTimeInterval:[self vlb_timeIntervalSinceNow]];
}


@end
