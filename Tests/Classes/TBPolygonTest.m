//
//  TBPolygonTest.m
//  thebox
//
//  Created by Markos Charatzas on 01/06/2013.
//  Copyright (c) 2013 TheBox. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import <Kiwi/Kiwi.h>
#import "TBPolygon.h"

@interface TBPolygonTest : SenTestCase

@end

@implementation TBPolygonTest

@end

SPEC_BEGIN(TBPolygonSpec)

context(@"given two new hexagons of same center", ^{
    it(@"asssert are equal", ^{
        TBPolygon *one = [TBPolygon hexagonAt:CGPointZero];
        TBPolygon *another = [TBPolygon hexagonAt:CGPointZero];
        TBPolygon *intermediate = [TBPolygon hexagonAt:CGPointZero];

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
        TBPolygon *one = [TBPolygon hexagonAt:CGPointZero];
        TBPolygon *another = [TBPolygon hexagonAt:CGPointZero];
        
        [[theValue(one.angleInRadians) should] equal:theValue(another.angleInRadians)];
        [[theValue(one.exteriorAngleInRadians) should] equal:theValue(another.exteriorAngleInRadians)];
        
    });
    
});

SPEC_END
