/*
 *  Copyright 2010 The Box
 *  All rights reserved.
 *
 *  This file is part of TheBox
 *
 *  Created by Markos Charatzas <[firstname.lastname@gmail.com]> on 12/12/10.
 *  Contributor(s): .-
 */
#import "TheBoxBundle.h"


@implementation TheBoxBundle

+(id)allocMainBundle{
return [[TheBoxBundle alloc] initWithBundle:[NSBundle mainBundle]];
}

@synthesize bundle;



-(id)initWithBundle:(NSBundle *) aBundle
{
	self = [super init];
	
	if (self) {
		self.bundle = aBundle;
	}
	
return self;
}

-(id)loadView:(NSString *)view
{
	NSArray *views = [self.bundle loadNibNamed:view owner:self options:nil];
return [views objectAtIndex:0];	
}

@end
