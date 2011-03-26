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
#import "TheBoxResponseParser.h"
#import "TheBoxResponseDelegate.h"
#import "TheBoxResponseParserTestDelegates.h"

@interface TheBoxResponseParserTest : SenTestCase {
	
}

@end 

@implementation TheBoxResponseParserTest


- (void) testParse 
{
	TheBoxResponseDelegateLogger *delegate = [TheBoxResponseParserTestDelegates newLoggingDelegate];
    TheBoxResponseParser *theBoxResponse = [[TheBoxResponseParser alloc] init];
	theBoxResponse.delegate = delegate;
	
	NSString* response = @"{\"items\":[	{\"id\":7,\"imageURL\":\"http://0.0.0.0:3000/system/images/7/thumb/aefjaef.jpg\",\"created_at\":\"2011-03-24T14:52:20Z\",\"when\":\"about 2 hours ago\",	\"category\":\"\"},	{\"id\":6,\"imageURL\":\"http://0.0.0.0:3000/system/images/6/thumb/sensation_media_chair.jpg\",\"created_at\":\"2011-03-24T14:31:52Z\",\"when\":\"about 3 hours ago\",\"category\":\"chair\"} ] }";
	
	[theBoxResponse parse:response];
	
	NSDictionary *data = [delegate data];
	STAssertNotNil(data, nil);
	
	NSArray *items = [data objectForKey:@"items"];
	STAssertNotNil(items, nil);
	
	NSInteger count = [items count];
	STAssertEquals(count, 2, nil);
		
	[response release];
	[theBoxResponse release];
}

@end
