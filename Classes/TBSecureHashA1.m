//
//  TBSecureHashA1.m
//  thebox
//
//  Created by Markos Charatzas on 21/11/2012.
//  Copyright (c) 2012 TheBox. All rights reserved.
//

#import "TBSecureHashA1.h"
#import "NSString+TBString.h"
#include <CommonCrypto/CommonDigest.h>

@interface TBSecureHashA1 ()
-(NSString*)uuid;
@end

@implementation TBSecureHashA1

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
    
return [NSString stringHexFromData:sha1hash size:CC_SHA1_DIGEST_LENGTH];
}

@end
