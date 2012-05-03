/*
 *  Copyright 2012 TheBox 
 *  All rights reserved.
 *
 *  This file is part of TheBox
 *
 *  Created by Markos Charatzas (@qnoid)  on 04/05/2012.
 *  Contributor(s): .-
 */
#import "NSDictionary+TBDictionary.h"

@implementation NSDictionary (TBDictionary)

-(id)tbObjectForKey:(id)aKey ifNil:(id)defaultObj
{
    id obj = [self objectForKey:aKey];
    
    if(!obj){
        return defaultObj;
    }
    
return obj;
}

@end
