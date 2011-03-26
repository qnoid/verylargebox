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
#import "TheBoxDataParser.h"

@interface TheBoxResponseParser ()

@property(nonatomic, retain) TheBoxDataParser *dataParser;

@end


@implementation TheBoxResponseParser

@synthesize dataParser;
@synthesize delegate;

- (void) dealloc
{
	[self.dataParser release];
	[super dealloc];
}

-(id) initWithDataParser:(TheBoxDataParser *)aDataParser
{
	self = [super init];
	
	if (self) {
		self.dataParser = aDataParser;
	}
	
return self;
}

#pragma mark private
TheBoxDataParser *dataParser;

- (void)response:(NSString*)response ok:(NSDictionary *)data
{
	[self.dataParser parse:data];
	[self.delegate response:response ok:data];
}

-(void)parse:(NSString *) response
{
	NSDictionary *data = [response JSONValue];
	[self response:response ok:data];
}

@end
