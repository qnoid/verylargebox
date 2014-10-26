//
//  TBsha1Test.m
//  verylargebox
//
//  Created by Markos Charatzas on 21/11/2012.
//  Copyright (c) 2012 (verylargebox.com). All rights reserved.
//

#import <XCTest/XCTest.h>
#import "VLBSecureHashA1.h"

@interface VLBSecureHashA1 (Testing)
-(NSString*)uuid;
@end

@interface VLBSecureHashA1Test : XCTestCase

@end

@implementation VLBSecureHashA1Test

/**
 @guards #testGivenNewAssertKeyNotNil
 */
-(void)testGivenNewAssertUUIDNotNil
{
    VLBSecureHashA1 *sha1 = [VLBSecureHashA1 new];
    
    NSString* uuid = [sha1 uuid];
    
    XCTAssertNotNil(uuid, @"%@", uuid);
}

/**
 @guards #testGivenNewAssertKeyCorrectLength
 */
-(void)testGivenNewAssertKeyNotNil
{
    VLBSecureHashA1 *sha1 = [VLBSecureHashA1 new];
    
    NSString* key = [sha1 newKey];
    
    XCTAssertNotNil(key);
    XCTAssertTrue(key.length == 40, @"%@", key);
}

-(void)testGivenNewAssertKeyCorrectLength
{
    VLBSecureHashA1 *sha1 = [VLBSecureHashA1 new];
    
    NSString* key = [sha1 newKey];
    
    XCTAssertTrue(key.length == 40, @"%@", key);
}

@end
