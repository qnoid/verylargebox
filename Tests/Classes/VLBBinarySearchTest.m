//
//
//  VLBBinarySearchTest.m
//  verylargebox
//
//  Created by Markos Charatzas on 16/04/2011.
//  Copyright (c) 2011 (verylargebox.com). All rights reserved.
//

#import <XCTest/XCTest.h>
#import "VLBBinarySearch.h"
#import "VLBTestRanking.h"
#import "VLBTestEqualsPredicate.h"

@interface VLBBinarySearchTest : XCTestCase {
	
}
@end

@implementation VLBBinarySearchTest


- (void) assertFind:(id)what on:(NSArray*)values withIndex:(NSUInteger)index
{
	id<VLBPredicate> ranking = [[VLBTestRanking alloc] init];
	
	VLBBinarySearch *search = [[VLBBinarySearch alloc]
                                    initWithPredicate:ranking];

    
    NSUInteger actual = [search find:what on:values];
    
	XCTAssertTrue(index == actual, @"expected: %@ actual %@", @(index), @(actual));
}

-(void)testEmptyArray
{
    NSArray *numbers = [NSArray new];
    
    [self assertFind:@"0" on:numbers withIndex:NSNotFound];
}

-(void)testDirectHit
{
    NSMutableArray *numbers = [NSMutableArray new];
    [numbers addObject:@"0"];
    
    [self assertFind:@"0" on:numbers withIndex:0];
}

-(void)testIndirectHit
{
    NSMutableArray *numbers = [NSMutableArray new];
    [numbers addObject:@"0"];
    [numbers addObject:@"1"];
    
    [self assertFind:@"0" on:numbers withIndex:0];
    [self assertFind:@"1" on:numbers withIndex:1];
}

-(void)testSingelMiss
{
    NSMutableArray *numbers = [NSMutableArray new];
    [numbers addObject:@"0"];
    [numbers addObject:@"1"];
    [numbers addObject:@"2"];
    
    [self assertFind:@"0" on:numbers withIndex:0];
    [self assertFind:@"1" on:numbers withIndex:1];
    [self assertFind:@"2" on:numbers withIndex:2];
}

-(void)testDoubleMiss
{
    NSMutableArray *numbers = [NSMutableArray new];
    [numbers addObject:@"0"];
    [numbers addObject:@"1"];
    [numbers addObject:@"2"];
    [numbers addObject:@"3"];
    
    [self assertFind:@"0" on:numbers withIndex:0];
    [self assertFind:@"1" on:numbers withIndex:1];
    [self assertFind:@"2" on:numbers withIndex:2];
    [self assertFind:@"3" on:numbers withIndex:3];
}

-(void)testMiss
{
    NSMutableArray *numbers = [NSMutableArray new];
    
    for (int i = 0; i < 10; i++) {
        [numbers addObject: [NSString stringWithFormat:@"%d", i] ];
    }
    
    [self assertFind:@"10" on:numbers withIndex:NSNotFound];
}

-(void)testIntegerMax
{
    NSMutableArray *numbers = [NSMutableArray new];
    
    [self assertFind:[NSString stringWithFormat:@"%lu", NSIntegerMax] on:numbers withIndex:NSNotFound];
}

@end
