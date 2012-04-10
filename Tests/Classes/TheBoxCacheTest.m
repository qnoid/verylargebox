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
#import "TheBoxCache.h"
#import "TheBoxTestDelegates.h"
#import "TheBox+Testing.h"

@interface TheBoxCacheTest : SenTestCase {
	
}
@end

@implementation TheBoxCacheTest

/*
 * @asserts TheBoxCache#objectForKey holds the cached response given the query
 */
- (void) testObjectForKey
{
	TheBoxCache *cache = [[TheBoxCache alloc] init];
	
	TheBox *theBox = [[TheBox alloc] initWithCache:cache responseParser:nil];
	
	id<TheBoxQuery> itemsQuery = [TheBoxTestQueries newItemsQuery];
	
	[theBox query:itemsQuery];    	
	
	STAssertNotNil([cache objectForKey:itemsQuery], 
				   @"Cache miss for key: %@", itemsQuery);
	
	[itemsQuery release];
	[theBox release];
	[cache release];
}

/*
 * @asserts that TheBox#query will only make the query once following hitting the cache
 */
- (void) testCacheHit
{
	TheBox *theBox = [TheBox checkIn];
	
	QueryCounter *query = [TheBoxTestQueries newQueryCounter];
	
	[theBox query:query];    	
	[theBox query:query];    	
	
	STAssertEquals(query.counter, 1, nil);
	
	[query release];
}

/*
 * @assert cache is a hit when using different references for queries
 */
- (void) testCacheHitOnDifferentReferences
{
	TheBox *theBox = [TheBox checkIn];
	
	QueryCounter *this = [TheBoxTestQueries newQueryCounter];
	QueryCounter *that = [TheBoxTestQueries newQueryCounter];
	
	[theBox query:this];    	
	[theBox query:that];    	
	
	STAssertEquals(this.counter, 1, nil);
	STAssertEquals(that.counter, 0, nil);
	
	[this release];
	[that release];
}

@end
