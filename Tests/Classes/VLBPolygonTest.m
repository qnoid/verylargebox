//
//  VLBPolygonTest.m
//  thebox
//
//  Created by Markos Charatzas on 01/06/2013.
//  Copyright (c) 2013 TheBox. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import <Kiwi/Kiwi.h>
#import "VLBPolygon.h"

@interface VLBPolygonTest : SenTestCase

@end

@implementation VLBPolygonTest

@end

SPEC_BEGIN(VLBPolygonSpec)

context(@"given two new hexagons of same center", ^{
    it(@"asssert are equal", ^{
        VLBPolygon *one = [VLBPolygon hexagonAt:CGPointZero];
        VLBPolygon *another = [VLBPolygon hexagonAt:CGPointZero];
        VLBPolygon *intermediate = [VLBPolygon hexagonAt:CGPointZero];

        //reflexive
        [[one should] equal:one];
        
        //symetric
        [[one should] equal:another];
        [[another should] equal:one];

        //transitive
        [[one should] equal:intermediate];
        [[intermediate should] equal:another];        
    });
    it(@"asssert are have equal angles", ^{
        VLBPolygon *one = [VLBPolygon hexagonAt:CGPointZero];
        VLBPolygon *another = [VLBPolygon hexagonAt:CGPointZero];
        
        [[theValue(one.angleInRadians) should] equal:theValue(another.angleInRadians)];
        [[theValue(one.exteriorAngleInRadians) should] equal:theValue(another.exteriorAngleInRadians)];
        
    });
    
});

SPEC_END