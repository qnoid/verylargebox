//
//  NSDictionary+VLBItem.h
//  thebox
//
//  Created by Markos Charatzas on 22/06/2013.
//  Copyright (c) 2013 verylargebox.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#define VLBItemKey NSString*

extern VLBItemKey const VLBItemLocation;
extern VLBItemKey const VLBItemWhen;
extern VLBItemKey const VLBItemIPhoneImageURL;
extern VLBItemKey const VLBItemLocality;

@interface NSDictionary (VLBItem)

-(NSDictionary*)vlb_locality;

-(NSDictionary*)vlb_location;

-(id)vlb_objectForKey:(VLBItemKey)key;

@end
