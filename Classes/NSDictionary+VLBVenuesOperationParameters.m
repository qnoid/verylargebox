//
//  NSDictionary+VLBVenuesOperationParameters.m
//  verylargebox
//
//  Created by Markos Charatzas on 15/06/2013.
//  Copyright (c) 2013 TheBox. All rights reserved.
//

#import "NSDictionary+VLBVenuesOperationParameters.h"

@implementation NSDictionary (VLBVenuesOperationParameters)

-(NSString*)vlb_query{
    return [self objectForKey:@"query"];
}

@end
