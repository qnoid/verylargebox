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
#import "TheBoxQueries.h"
#import "TheBoxGet.h"
#import "TheBoxPost.h"

/*
 * Asserts equality of all the queries as returned by TheBoxQueries.
 *
 * @guards TheBoxCacheTest
 */
@interface TheBoxQueriesTest : SenTestCase {
	
}

@end

@implementation TheBoxQueriesTest

-(void)testNewItemsQuery
{
	id<TheBoxQuery> this = [TheBoxQueries itemsQuery];
	id<TheBoxQuery> that = [TheBoxQueries itemsQuery];
	
	STAssertTrue([this isEqual:that], nil);	
}

-(void)testNewItemQuery
{
	id<TheBoxQuery> this = [TheBoxQueries itemQuery:nil 
										  itemName:nil 
										  locationName:nil 
										  categoryName:nil 
										  tags:nil];
	
	id<TheBoxQuery> that = [TheBoxQueries itemQuery:nil 
										  itemName:nil 
										  locationName:nil 
										  categoryName:nil 
										  tags:nil];
	
	STAssertTrue([this isEqual:that], nil);	
}

@end
