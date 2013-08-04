//
//  NSObject+VLBObject.m
//  verylargebox
//
//  Created by Markos Charatzas on 04/08/2013.
//  Copyright (c) 2013 verylargebox.com. All rights reserved.
//

#import "NSObject+VLBObject.h"

@implementation NSObject (VLBObject)
+(BOOL)vlb_isNil:(id)obj{
    return nil == obj || [NSNull null] == obj;
}
@end
