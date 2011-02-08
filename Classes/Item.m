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

@synthesize image;
@synthesize value;
@synthesize when;

- (void) dealloc
{
	[self.image release];
	[self.value release];
	[self.when release];
	[super dealloc];
}



@end
