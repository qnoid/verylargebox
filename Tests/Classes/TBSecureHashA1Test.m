//
//  TBsha1Test.m
//  thebox
//
//  Created by Markos Charatzas on 21/11/2012.
//  Copyright (c) 2012 TheBox. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import "TBSecureHashA1.h"

@interface TBSecureHashA1 (Testing)
-(NSString*)uuid;
@end

@interface TBSecureHashA1Test : SenTestCase

@end

@implementation TBSecureHashA1Test

/**
 @guards #testGivenNewAssertKeyNotNil
 */
-(void)testGivenNewAssertUUIDNotNil
{
    TBSecureHashA1 *sha1 = [TBSecureHashA1 new];
    
    NSString* uuid = [sha1 uuid];
    
    STAssertNotNil(uuid, @"%@", uuid);
}

/**
 @guards #testGivenNewAssertKeyCorrectLength
 */
-(void)testGivenNewAssertKeyNotNil
{
    TBSecureHashA1 *sha1 = [TBSecureHashA1 new];
    
    NSString* key = [sha1 newKey];
    
    STAssertNotNil(key, key);
    STAssertTrue(key.length == 40, @"%@", key);
}

-(void)testGivenNewAssertKeyCorrectLength
{
    TBSecureHashA1 *sha1 = [TBSecureHashA1 new];
    
    NSString* key = [sha1 newKey];
    
    STAssertTrue(key.length == 40, @"%@", key);
}

@end
