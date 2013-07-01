//
//  NSString+TBString.m
//  verylargebox
//
//  Created by Markos Charatzas on 21/11/2012.
//  Copyright (c) 2012 (verylargebox.com). All rights reserved.
//

#import "NSString+VLBString.h"

@implementation NSString (VLBString)

+(NSString*)vlb_stringHexFromData:(uint8_t[])data size:(NSUInteger)length;
{
    NSMutableString* hex = [NSMutableString stringWithCapacity:length * 2];
    
    for(int i = 0; i < length; i++){
        [hex appendFormat:@"%02X", data[i]];
    }
    
return hex;
}
@end
