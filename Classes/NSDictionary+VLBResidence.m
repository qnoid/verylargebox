//
//  NSDictionary+TBResidence.m
//  verylargebox
//
//  Created by Markos Charatzas on 15/06/2013.
//  Copyright (c) 2013 (verylargebox.com). All rights reserved.
//

#import "NSDictionary+VLBResidence.h"
#import "NSDictionary+VLBUser.h"


VLBResidenceKey const VLBResidenceUserId = @"user_id";
VLBResidenceKey const VLBResidenceToken = @"token";
VLBResidenceKey const VLBResidence = @"residence";
VLBResidenceKey const VLBResidenceUserKey = @"user";

@implementation NSDictionary (VLBResidence)

-(NSDictionary*)vlb_user {
    return [self objectForKey:VLBResidenceUserKey];
}

-(NSUInteger)vlb_residenceUserId {
    return [[self vlb_objectForKey:VLBResidenceUserId] unsignedIntValue];
}

-(id)vlb_objectForKey:(VLBResidenceKey)key {
    return [self objectForKey:key];
}

-(BOOL)vlb_hasUserTakenPhoto
{
    id didTakePhoto = [[self vlb_objectForKey:VLBResidenceUserKey] vlb_objectForKey:VLBUserDidTakePhotoKey];
    
return [NSNull null] != didTakePhoto && [didTakePhoto intValue] == 1;
}

@end
