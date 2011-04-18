/*
 *  Copyright 2010 TheBox
 *  All rights reserved.
 *
 *  This file is part of TheBox
 *
 *  Created by Markos Charatzas <[firstname.lastname@gmail.com]> on 26/03/2011.
 *  Contributor(s): .-
 */
#import "TheBoxResponseParser.h"
#import "JSON.h"
#import "TheBoxCompositeDataParser.h"

@interface TheBoxResponseParser ()

@property(nonatomic, retain) TheBoxCompositeDataParser *dataParser;

@end


@implementation TheBoxResponseParser

@synthesize dataParser;
@synthesize delegate;

- (void) dealloc
{
	[self.dataParser release];
	[super dealloc];
}

-(id) initWithDataParser:(TheBoxCompositeDataParser *)aDataParser
{
	self = [super init];
	
	if (self) {
		self.dataParser = aDataParser;
	}
	
return self;
}

#pragma mark private
TheBoxCompositeDataParser *dataParser;

- (void)response:(NSString*)response ok:(id)data
{
	[self.dataParser parse:data];
	[self.delegate response:response ok:data];
}

-(void)parse:(NSString *) response
{
	id data = [response JSONValue];
	[self response:response ok:data];
}

@end
