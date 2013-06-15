//
//  Copyright 2012 TheBox 
//  All rights reserved.
//
//  This file is part of TheBox
//
//  Created by Markos Charatzas on 24/04/2012.
//
//

#import "NSCache+VLBCache.h"

@implementation NSCache (VLBCache)

-(id)vlb_objectForKey:(id)aKey ifNilReturn:(id)defaultObject
{
    id obj = [self objectForKey:aKey];
    
    if(obj == nil){
        return defaultObject;
    }
    
return obj;    
}

@end
