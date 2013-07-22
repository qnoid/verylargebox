//
//  NSDictionary+VLBUser.m
//  verylargebox
//
//  Created by Markos Charatzas on 05/07/2013.
//  Copyright (c) 2013 verylargebox.com. All rights reserved.
//

#import "NSDictionary+VLBUser.h"

VLBUserKey const VLBUserDidTakePhotoKey = @"did_take_photo";
VLBUserKey const VLBUserEmail = @"email";

@implementation NSDictionary (VLBUser)

-(id)vlb_objectForKey:(VLBUserKey)key {
    return [self objectForKey:key];
}

@end
