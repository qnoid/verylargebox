//
//  TBNSString+TBSStringTestCase.m
//  thebox
//
//  Created by Markos Charatzas on 22/11/2012.
//  Copyright (c) 2012 TheBox. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import "NSString+VLBString.h"

@interface VLBNSString_VLBNStringTestCase : SenTestCase

@end

@implementation VLBNSString_VLBNStringTestCase

-(void)testGivenEmptyDataAssertEmptyString
{
    uint8_t data[0];
    NSString* hex = [NSString vlb_stringHexFromData:data size:0];
    
    STAssertNotNil(hex, hex);
    STAssertTrue(hex.length == 0, hex);
}

-(void)testGivenOneDigitDataAssertHex
{
    uint8_t data[] = {'1'};
    NSUInteger length = 1;
    NSString* hex = [NSString vlb_stringHexFromData:data size:length];
    
    STAssertTrue(hex.length == 2 * length, hex);
    STAssertEqualObjects(hex, @"31", hex);
}

@end
