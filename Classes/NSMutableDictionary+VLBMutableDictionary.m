//
//  Copyright 2012 TheBox 
//  All rights reserved.
//
//  This file is part of TheBox
//
//  Created by Markos Charatzas on 18/04/2012.
//
//

#import "NSMutableDictionary+VLBMutableDictionary.h"
#import "NSString+VLBDecorator.h"

@implementation NSMutableDictionary (VLBMutableDictionary)

-(void)vlb_setStringIfNotNilOrEmpty:(NSString*)string forKey:(id)key
{
    if(string == nil || [string vlb_isEmpty]){
        return;
    }
    
    [self setObject:string forKey:key];
}

-(void)vlb_setObjectIfNotNil:(id)object forKey:(id)key
{
    if(object == nil){
        return;
    }
    
    [self setObject:object forKey:key];
}

@end
