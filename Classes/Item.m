/*
 *  Copyright 2010 The Box
 *  All rights reserved.
 *
 *  This file is part of TheBox
 *
 *  Created by Markos Charatzas <[firstname.lastname@gmail.com]> on 15/12/10.
 *  Contributor(s): .-
 */
#import "Item.h"


@implementation Item

@synthesize imageURL;
@synthesize when;
@synthesize createdAt;

- (void) dealloc
{
	[self.imageURL release];
	[self.when release];
	[self.createdAt release];
	[super dealloc];
}


@end
