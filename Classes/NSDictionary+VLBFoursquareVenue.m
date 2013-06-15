//
//  NSDictionary+VLBFoursquareVenue.m
//  thebox
//
//  Created by Markos Charatzas on 15/06/2013.
//  Copyright (c) 2013 TheBox. All rights reserved.
//

#import "NSDictionary+VLBFoursquareVenue.h"

@implementation NSDictionary (VLBFoursquareVenue)

-(NSString*)vlb_name{
    return [self objectForKey:@"name"];
}

@end
