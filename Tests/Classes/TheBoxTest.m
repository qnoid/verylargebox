/*
 *  Copyright 2010 TheBox
 *  All rights reserved.
 *
 *  This file is part of TheBox
 *
 *  Created by Markos Charatzas <[firstname.lastname@gmail.com]> on 25/03/2011.
 *  Contributor(s): .-
 */
#import <SenTestingKit/SenTestingKit.h>
#import "TheBoxQuery.h"
#import "TheBoxDelegate.h"
#import "TheBoxTestDelegates.h"
#import "TheBoxDataParserTestDelegates.h"

@interface TheBoxTest : SenTestCase {
}
@end

@implementation TheBoxTest

- (void) testUsage 
{
	id<TheBoxDelegate> delegate = [TheBoxTestDelegates newLoggingDelegate];
	
	TheBox *theBox = [TheBox checkIn];
	theBox.delegate = delegate;
	
	id<TheBoxQuery> itemsQuery = [TheBoxTestQueries newItemsQuery];
	
	[theBox query:itemsQuery];
    
	NSString *actual = [delegate description];
	STAssertTrue([@"items" isEqualToString:actual], @"Should be equal to '%@' ", actual);
	
	[itemsQuery release];
	[delegate release];	
}

- (void) testBuilder
{
	TheBoxDataParserDelegateLogger* delegate = [TheBoxDataParserTestDelegates newLoggingDelegate:2];
	TheBoxBuilder* builder = [[TheBoxBuilder alloc] init];
	[builder dataParserDelegate:delegate];
	
	TheBox *theBox = [builder build];
	
	id<TheBoxQuery> itemsQuery = [TheBoxTestQueries newItemsQuery];
	
	[theBox query:itemsQuery];
    
	NSArray *actualItems = [delegate items];
	STAssertNotNil(actualItems, nil);
	
	[itemsQuery release];
	[delegate release];	
}

@end
