/*
 *  Copyright 2010 TheBox
 *  All rights reserved.
 *
 *  This file is part of TheBox
 *
 *  Created by Markos Charatzas <[firstname.lastname@gmail.com]> on 20/03/2011.
 *  Contributor(s): .-
 */
#import "TheBox.h"
#import "TheBoxQuery.h"
#import "TheBoxDelegate.h"
#import "TheBoxCache.h"
#import "TheBoxResponseParser.h"
#import "TheBoxDataParser.h"

static NSString* theBoxURL = @"http://0.0.0.0:3000";
static NSString* theBoxItemsPrefix = @"/items";

/*
 * (not so) private declarations
 */
@interface TheBox ()
	@property(nonatomic, retain) TheBoxCache *cache;
	@property(nonatomic, retain) TheBoxResponseParser *responseParser;
	-(id)initWithCache:(TheBoxCache *)cache responseParser:(TheBoxResponseParser*)responseParser;
@end


@implementation TheBox

#pragma mark static
+(TheBox*) checkIn 
{
	TheBoxBuilder *builder = [[TheBoxBuilder alloc] init];
	
	TheBox* theBox = [builder build];
	
	[builder release];
	
return theBox;
}

@synthesize responseParser;
@synthesize cache;
@synthesize delegate;

- (void) dealloc
{
	[self.responseParser release];
	[self.cache release];
	[super dealloc];
}

#pragma mark private
TheBoxCache *cache;
TheBoxResponseParser *responseParser;

-(id)initWithCache:(TheBoxCache *)aCache responseParser:(TheBoxResponseParser*)aResponseParser
{
	self = [super init];
	
	if (self) {
		self.cache = aCache;
		self.responseParser = aResponseParser;
	}
	
return self;
}

/*
 * implemented to intercept calls to the delegate
 * caches the query and response object
 */
- (void)query:(id<TheBoxQuery>)query ok:(NSString *)response
{
	[self.cache setObject:response forKey:query];
	[self.responseParser parse:response];
	[self.delegate query:query ok:response];
}

#pragma mark public
-(void)query:(id<TheBoxQuery>)query
{
	id hit = [self.cache objectForKey:query];
	
	if(hit){
		[self query:query ok:hit];
	return;
	}
		
	[query make:self];
}

@end

@interface TheBoxBuilder ()

@property(nonatomic, retain) TheBoxCache *cache;
@property(nonatomic, retain) TheBoxResponseParser *responseParser;
@property(nonatomic, retain) TheBoxDataParser *dataParser;

@end


@implementation TheBoxBuilder

@synthesize cache;
@synthesize responseParser;
@synthesize dataParser;

TheBoxCache *cache;
TheBoxResponseParser *responseParser;
TheBoxDataParser *dataParser;

-(void) dealloc
{
	[self.cache release];
	[self.responseParser release];
	[self.dataParser release];
	[super dealloc];
}


-(id) init
{
	self = [super init];
	
	if (self) 
	{
		TheBoxDataParser *aDataParser = [[TheBoxDataParser alloc] init];
		TheBoxResponseParser *aResponseParser = [[TheBoxResponseParser alloc] initWithDataParser:aDataParser];
		TheBoxCache* aCache = [[TheBoxCache alloc] init];
		
		self.dataParser = aDataParser;
		self.responseParser = aResponseParser;
		self.cache = aCache;
		
		[aCache release];
		[aResponseParser release];
		[aDataParser release];
		
	}
return self;
}

-(void)delegate:(id<TheBoxDataDelegate>)delegate {
	self.dataParser.delegate = delegate;
}

-(TheBox*) build {
return [[[TheBox alloc] initWithCache:self.cache responseParser:self.responseParser] autorelease];		
}

@end

