/*
 *  Copyright 2010 TheBox
 *  All rights reserved.
 *
 *  This file is part of TheBox
 *
 *  Created by Markos Charatzas <[firstname.lastname@gmail.com]> on 16/04/2011.
 *  Contributor(s): .-
 */
#import <SenTestingKit/SenTestingKit.h>
#import "TheBoxBinarySearch.h"
#import "TheBoxTestRanking.h"
#import "TheBoxTestEqualsPredicate.h"

@interface TheBoxBinarySearchTest : SenTestCase {
	
}
@end

@implementation TheBoxBinarySearchTest


- (void) testFindOn 
{
	id<TheBoxPredicate> ranking = [[[TheBoxTestRanking alloc] init:6] autorelease];
	
	TheBoxBinarySearch *search = [[[TheBoxBinarySearch alloc] init] autorelease];
    	
	[search find:ranking on:[NSArray arrayWithObjects:0, 1, 2, 3, 4, 5, 6, 7, 8, 9, nil]];
}
@end
