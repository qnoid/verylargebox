//
//  TBsha1Test.m
//  thebox
//
//  Created by Markos Charatzas on 21/11/2012.
//  Copyright (c) 2012 (verylargebox.com). All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import "VLBSecureHashA1.h"

@interface VLBSecureHashA1 (Testing)
-(NSString*)uuid;
@end

@interface VLBSecureHashA1Test : SenTestCase

@end

@implementation VLBSecureHashA1Test

/**
 @guards #testGivenNewAssertKeyNotNil
 */
-(void)testGivenNewAssertUUIDNotNil
{
    VLBSecureHashA1 *sha1 = [VLBSecureHashA1 new];
    
    NSString* uuid = [sha1 uuid];
    
    STAssertNotNil(uuid, @"%@", uuid);
}

/**
 @guards #testGivenNewAssertKeyCorrectLength
 */
-(void)testGivenNewAssertKeyNotNil
{
    VLBSecureHashA1 *sha1 = [VLBSecureHashA1 new];
    
    NSString* key = [sha1 newKey];
    
    STAssertNotNil(key, key);
    STAssertTrue(key.length == 40, @"%@", key);
}

-(void)testGivenNewAssertKeyCorrectLength
{
    VLBSecureHashA1 *sha1 = [VLBSecureHashA1 new];
    
    NSString* key = [sha1 newKey];
    
    STAssertTrue(key.length == 40, @"%@", key);
}

@end
