/**
 *  Copyright 2012 TheBox 
 *  All rights reserved.
 *
 *  This file is part of TheBox
 *
 *  Created by Markos Charatzas (@qnoid)  on 24/04/2012.
 *  Contributor(s): .-
 */
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
