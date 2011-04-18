/*
 *  Copyright 2010 TheBox
 *  All rights reserved.
 *
 *  This file is part of TheBox
 *
 *  Created by Markos Charatzas <[firstname.lastname@gmail.com]> on 16/04/2011.
 *  Contributor(s): .-
 */
#import "TheBoxTestRanking.h"


@implementation TheBoxTestRanking

@synthesize object;

-(id)init:(id)anObject
{
	self = [super init];
	
	if (self) {
		self.object = anObject;
	}
	
	return self;
}

-(BOOL)applies:(id)anObject{
return [object isEqual:anObject];
}

-(BOOL)isHigherThan:(id)anObject {
return object > anObject;
}

@end
