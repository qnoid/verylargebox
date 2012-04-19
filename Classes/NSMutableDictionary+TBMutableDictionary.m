/*
 *  Copyright 2012 TheBox 
 *  All rights reserved.
 *
 *  This file is part of TheBox
 *
 *  Created by Markos Charatzas (@qnoid)  on 18/04/2012.
 *  Contributor(s): .-
 */
#import "NSMutableDictionary+TBMutableDictionary.h"

@implementation NSMutableDictionary (TBMutableDictionary)

-(void)tbSetObjectIfNotNil:(id)object forKey:(id)key
{
    if(object == nil){
        return;
    }
    
    [self setObject:object forKey:key];
}

@end
