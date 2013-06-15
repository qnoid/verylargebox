//
//  NSString+TBString.h
//  thebox
//
//  Created by Markos Charatzas on 21/11/2012.
//  Copyright (c) 2012 (verylargebox.com). All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 Category on NSString
 */
@interface NSString (VLBString)

/**
 Creates a new hex NSString that represents the given data.
 Each character in data is created in the equivelent hex.
 
 @param data the char array to convert to an hex NSString
 @param length the length of the data array
 @return a hex NSString that has double the length of the given data
 */
+(NSString*)vlb_stringHexFromData:(uint8_t[])data size:(NSUInteger)length;

@end
