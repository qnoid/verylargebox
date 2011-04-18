/*
 *  Copyright 2010 TheBox
 *  All rights reserved.
 *
 *  This file is part of TheBox
 *
 *  Created by Markos Charatzas <[firstname.lastname@gmail.com]> on 02/04/2011.
 *  Contributor(s): .-
 */
#import "TheBoxSingleDataParser.h"
#import "TheBoxDataParserDelegate.h"

@implementation TheBoxSingleDataParser

@synthesize delegate;

-(void)parse:(NSDictionary *) data
{
	NSNumber* theId = [data objectForKey:@"id"];
	[self.delegate element:[theId intValue] with:data];
}

@end
