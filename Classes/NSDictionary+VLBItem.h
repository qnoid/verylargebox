//
//  NSDictionary+VLBItem.h
//  verylargebox
//
//  Created by Markos Charatzas on 22/06/2013.
//  Copyright (c) 2013 verylargebox.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#define VLBItemKey NSString*

extern VLBItemKey const VLBItemId;
extern VLBItemKey const VLBItemLocation;
extern VLBItemKey const VLBItemWhen;
extern VLBItemKey const VLBItemImageURL;
extern VLBItemKey const VLBItemIPhoneImageURL;
extern VLBItemKey const VLBItemLocality;
extern VLBItemKey const VLBItemImageKey;

@interface NSDictionary (VLBItem)

-(NSDictionary*)vlb_locality;

-(NSDictionary*)vlb_location;

-(id)vlb_objectForKey:(VLBItemKey)key;

-(NSString*)vlb_when;

@end
