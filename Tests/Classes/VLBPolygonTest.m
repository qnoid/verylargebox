//
//  VLBPolygonTest.m
//  verylargebox
//
//  Created by Markos Charatzas on 01/06/2013.
//  Copyright (c) 2013 (verylargebox.com). All rights reserved.
//

#import <XCTest/XCTest.h>
#import "VLBPolygon.h"

@interface VLBPolygonTest : XCTestCase

@end

@implementation VLBPolygonTest

-(void)testGivenTwoNewHexagonsOfSameCenterAsssertEqual
{
    VLBPolygon *one = [VLBPolygon hexagonAt:CGPointZero];
    VLBPolygon *another = [VLBPolygon hexagonAt:CGPointZero];
    VLBPolygon *intermediate = [VLBPolygon hexagonAt:CGPointZero];

    //reflexive
    XCTAssertEqual(one, one);
    
    //symetric
    XCTAssertEqual(one, another);
    XCTAssertEqual(another, one);

    //transitive
    XCTAssertEqual(one, intermediate);
    XCTAssertEqual(intermediate, one);
}

-(void)testGivenTwoNewHexagonsOfSameCenterAsssertEqualAngles
{
    VLBPolygon *one = [VLBPolygon hexagonAt:CGPointZero];
    VLBPolygon *another = [VLBPolygon hexagonAt:CGPointZero];
    
    XCTAssertEqual(one.angleInRadians, another.angleInRadians);
    XCTAssertEqual(one.exteriorAngleInRadians, another.exteriorAngleInRadians);
}

@end
