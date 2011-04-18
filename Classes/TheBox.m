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
#import "TheBoxResponseParserDelegate.h"
#import "TheBoxCompositeDataParser.h"
#import "ASIHTTPRequest.h"
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
@property(nonatomic, retain) id<TheBoxResponseParserDelegate> responseParserDelegate;
@property(nonatomic, retain) TheBoxCompositeDataParser *dataParser;

@end


@implementation TheBoxBuilder

@synthesize cache;
@synthesize responseParserDelegate;
@synthesize dataParser;

TheBoxCache *cache;
id<TheBoxResponseParserDelegate> *responseParserDelegate;
TheBoxCompositeDataParser *dataParser;

-(void) dealloc
{
	[self.cache release];
	[self.responseParserDelegate release];
	[self.dataParser release];
	[super dealloc];
}


-(id) init
{
	self = [super init];
	
	if (self) 
	{
		TheBoxCompositeDataParser *aDataParser = [[TheBoxCompositeDataParser alloc] init];
		TheBoxCache* aCache = [[TheBoxCache alloc] init];
		
		self.dataParser = aDataParser;
		self.cache = aCache;
		
		[aCache release];
		[aDataParser release];
		
	}
return self;
}

-(void)dataParser:(id<TheBoxDataParser>)aDataParser {
	self.dataParser = aDataParser;
}

-(void)responseParserDelegate:(id<TheBoxResponseParserDelegate>)delegate {
	self.responseParserDelegate = delegate;
}


-(void)dataParserDelegate:(id<TheBoxDataParserDelegate>)delegate {
	self.dataParser.delegate = delegate;
}

-(TheBox*) build 
{
	TheBoxResponseParser *aResponseParser = [[TheBoxResponseParser alloc] initWithDataParser:self.dataParser];
	aResponseParser.delegate = self.responseParserDelegate;
	TheBox *theBox = [[[TheBox alloc] 
					   initWithCache:self.cache 
					   responseParser:aResponseParser] autorelease];
	
	[aResponseParser release];

return theBox;		
}

@end

