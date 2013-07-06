//
//  NSDictionary+VLBUser.h
//  verylargebox
//
//  Created by Markos Charatzas on 05/07/2013.
//  Copyright (c) 2013 verylargebox.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#define VLBUserKey NSString*

extern VLBUserKey const VLBUserDidTakePhotoKey;

@interface NSDictionary (VLBUser)

-(id)vlb_objectForKey:(VLBUserKey)key;

@end
