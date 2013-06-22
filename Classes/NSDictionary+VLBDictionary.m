//
//  Copyright 2012 TheBox 
//  All rights reserved.
//
//  This file is part of TheBox
//
//  Created by Markos Charatzas on 04/05/2012.
//
//

#import "NSDictionary+VLBDictionary.h"

@implementation NSDictionary (VLBDictionary)

-(id)vlb_objectForKey:(id)aKey ifNil:(id)defaultObj
{
    id obj = [self objectForKey:aKey];
    
    if(!obj || [NSNull null] == obj){
        return defaultObj;
    }
    
return obj;
}

@end
