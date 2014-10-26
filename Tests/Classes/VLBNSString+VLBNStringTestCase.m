//
//  TBNSString+TBSStringTestCase.m
//  verylargebox
//
//  Created by Markos Charatzas on 22/11/2012.
//  Copyright (c) 2012 (verylargebox.com). All rights reserved.
//

#import <XCTest/XCTest.h>
#import "NSString+VLBString.h"

@interface VLBNSString_VLBNStringTestCase : XCTestCase

@end

@implementation VLBNSString_VLBNStringTestCase

-(void)testGivenEmptyDataAssertEmptyString
{
    uint8_t data[0];
    NSString* hex = [NSString vlb_stringHexFromData:data size:0];
    
    XCTAssertNotNil(hex);
    XCTAssertTrue(hex.length == 0);
}

-(void)testGivenOneDigitDataAssertHex
{
    uint8_t data[] = {'1'};
    NSUInteger length = 1;
    NSString* hex = [NSString vlb_stringHexFromData:data size:length];
    
    XCTAssertTrue(hex.length == 2 * length);
    XCTAssertEqualObjects(hex, @"31");
}

@end
