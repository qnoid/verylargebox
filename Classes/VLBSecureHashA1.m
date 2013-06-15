//
//  VLBSecureHashA1.m
//  thebox
//
//  Created by Markos Charatzas on 21/11/2012.
//  Copyright (c) 2012 TheBox. All rights reserved.
//

#import "VLBSecureHashA1.h"
#import "NSString+VLBString.h"
#include <CommonCrypto/CommonDigest.h>

@interface VLBSecureHashA1 ()
-(NSString*)uuid;
@end

@implementation VLBSecureHashA1

-(NSString*)uuid
{
    CFUUIDRef uuid = CFUUIDCreate(kCFAllocatorDefault);
    NSString *uuidStr = (__bridge_transfer NSString *)CFUUIDCreateString(kCFAllocatorDefault, uuid);
    CFRelease(uuid);
    
return uuidStr;
}

-(NSString*)newKey {
return [self newKey:[self uuid]];
}

-(NSString*)newKey:(NSString*)digest
{
    uint8_t sha1hash[CC_SHA1_DIGEST_LENGTH];
    NSData* uuid = [digest dataUsingEncoding:NSUTF8StringEncoding];
    
    if (!CC_SHA1(uuid.bytes, uuid.length, sha1hash) ) {
        return nil;
    }
    
return [NSString vlb_stringHexFromData:sha1hash size:CC_SHA1_DIGEST_LENGTH];
}

@end
