//
//  TBSecureHashA1.h
//  thebox
//
//  Created by Markos Charatzas on 21/11/2012.
//  Copyright (c) 2012 TheBox. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
  An implementation of the SHA-1 cryptographic hash function.
 */
@interface TBSecureHashA1 : NSObject

/**
 Generates a UUID SHA-1 hash based.
 
 @return a new hex encoded NSString of 40 bytes.
 @see CC_SHA1
 */
-(NSString*)newKey;


/**
 Encrypts the given digest using the SHA-1 algorithm.
 
 @param digest the key to
 @return a new hex encoded NSString of 40 bytes.
 */
-(NSString*)newKey:(NSString*)digest;
@end
