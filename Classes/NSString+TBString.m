//
//  NSString+TBString.m
//  thebox
//
//  Created by Markos Charatzas on 21/11/2012.
//  Copyright (c) 2012 TheBox. All rights reserved.
//

#import "NSString+TBString.h"

@implementation NSString (TBString)

+(NSString*)stringHexFromData:(uint8_t[])data size:(NSUInteger)length;
{
    NSMutableString* hex = [NSMutableString stringWithCapacity:length * 2];
    
    for(int i = 0; i < length; i++){
        [hex appendFormat:@"%02X", data[i]];
    }
    
return hex;
}
@end