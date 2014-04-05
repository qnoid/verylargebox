//
//  NSString+VLBJson.m
//  verylargebox
//
//  Created by Markos Charatzas on 02/11/2013.
//  Copyright (c) 2013 verylargebox.com. All rights reserved.
//

#import "NSString+VLBJson.h"

@implementation NSString (VLBJson)

-(id)vlb_jsonObject
{
    NSError* error = [[NSError alloc] init];
    
    return [NSJSONSerialization JSONObjectWithData: [self dataUsingEncoding:NSUTF8StringEncoding]
                                           options: NSJSONReadingMutableContainers
                                             error: &error];
    
    DDLogCError(@"%@", error);
}
@end
