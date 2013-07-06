//
//  NSDictionary+TBResidence.h
//  verylargebox
//
//  Created by Markos Charatzas on 15/06/2013.
//  Copyright (c) 2013 (verylargebox.com). All rights reserved.
//

#import <Foundation/Foundation.h>

#define VLBResidenceKey NSString*

extern VLBResidenceKey const VLBResidenceUserId;
extern VLBResidenceKey const VLBResidenceToken;
extern VLBResidenceKey const VLBResidence;
extern VLBResidenceKey const VLBResidenceUserKey;

@interface NSDictionary (VLBResidence)

-(NSUInteger)vlb_residenceUserId;

-(id)vlb_objectForKey:(VLBResidenceKey)key;
@end
