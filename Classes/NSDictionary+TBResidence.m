//
//  NSDictionary+TBResidence.m
//  thebox
//
//  Created by Markos Charatzas on 15/06/2013.
//  Copyright (c) 2013 TheBox. All rights reserved.
//

#import "NSDictionary+TBResidence.h"

@implementation NSDictionary (TBResidence)

-(NSUInteger)tbResidenceUserId {
    return [[self objectForKey:@"user_id"] unsignedIntValue];
}

@end
