//
//  NSDictionary+TBResidence.m
//  thebox
//
//  Created by Markos Charatzas on 15/06/2013.
//  Copyright (c) 2013 (verylargebox.com). All rights reserved.
//

#import "NSDictionary+VLBResidence.h"


NSString* const VLBResidenceUserId = @"user_id";
NSString* const VLBResidenceToken = @"token";
NSString* const VLBResidence = @"residence";

@implementation NSDictionary (VLBResidence)

-(NSUInteger)vlb_residenceUserId {
    return [[self vlb_objectForKey:VLBResidenceUserId] unsignedIntValue];
}

-(id)vlb_objectForKey:(VLBResidenceKey)key {
    return [self objectForKey:key];
}

@end
