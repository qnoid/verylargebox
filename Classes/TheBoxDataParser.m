/*
 *  Copyright 2010 TheBox
 *  All rights reserved.
 *
 *  This file is part of TheBox
 *
 *  Created by Markos Charatzas <[firstname.lastname@gmail.com]> on 26/03/2011.
 *  Contributor(s): .-
 */
#import "TheBoxDataParser.h"


@implementation TheBoxDataParser

@synthesize delegate;

-(void)parse:(NSDictionary *) data
{
	NSArray* items = [data objectForKey:@"items"];
	
	for (NSDictionary* item in items) 
	{
		NSString* theId = [item objectForKey:@"id"];
		[self.delegate element:[theId intValue] with:item];
	}
}

@end
