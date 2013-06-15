//
//  NSDictionary+TBResidence.m
//  thebox
//
//  Created by Markos Charatzas on 15/06/2013.
//  Copyright (c) 2013 (verylargebox.com). All rights reserved.
//

#import "NSDictionary+VLBResidence.h"

@implementation NSDictionary (VLBResidence)

-(NSUInteger)vlb_residenceUserId {
    return [[self objectForKey:@"user_id"] unsignedIntValue];
}

@end
