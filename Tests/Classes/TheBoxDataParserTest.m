/*
 *  Copyright 2010 TheBox
 *  All rights reserved.
 *
 *  This file is part of TheBox
 *
 *  Created by Markos Charatzas <[firstname.lastname@gmail.com]> on 26/03/2011.
 *  Contributor(s): .-
 */
#import <SenTestingKit/SenTestingKit.h>
#import "TheBoxCompositeDataParser.h"
#import "TheBoxDataParserDelegate.h"
#import "TheBoxDataParserTestDelegates.h"

@interface TheBoxDataParserTest : SenTestCase {
	
}

@end

@implementation TheBoxDataParserTest

- (void) testParse
{
	TheBoxDataParserDelegateLogger *delegate = [TheBoxDataParserTestDelegates newLoggingDelegate:2];
    TheBoxCompositeDataParser* dataParser = [[TheBoxCompositeDataParser alloc] init];
	dataParser.delegate = delegate;
	
	NSDictionary *oneItem = [NSDictionary dictionaryWithObject:@"0" forKey:@"id"];
	NSDictionary *secondItem = [NSDictionary dictionaryWithObject:@"1" forKey:@"id"];
	NSArray *items = [NSArray arrayWithObjects:oneItem, secondItem, nil];	
	NSDictionary *data = [NSDictionary dictionaryWithObject:items forKey:@"items"];
	
	[dataParser parse:data];
	
	NSArray* actualItems = [delegate items];
	STAssertNotNil(actualItems, nil);
	
	NSInteger actualCount = [actualItems count];	
	STAssertEquals(actualCount, 2, nil);

	NSDictionary *actualItem = [actualItems objectAtIndex:0];
	STAssertNotNil(actualItem, nil);	
	
	NSString *theId = [actualItem objectForKey:@"id"];
	STAssertNotNil(theId, nil);	
	STAssertEquals([theId intValue], 0, nil);
	
	STAssertTrue([actualItem isEqual:oneItem], nil);
	
	[dataParser release];
}

@end
