/*
 *  Copyright 2010 The Box
 *  All rights reserved.
 *
 *  This file is part of TheBox
 *
 *  Created by Markos Charatzas (@qnoid) on 15/12/10.
 *  Contributor(s): .-
 */
#import "Item.h"


@implementation Item

@synthesize identifier;
@synthesize imageURL;
@synthesize when;
@synthesize createdAt;


-(NSString *) description{
return [self.imageURL description];
}

-(NSUInteger) hash{
return identifier;
}

-(BOOL) isEqual:(id)that
{
	if (self == that) {
		return YES;
	}
	
	if (![that isKindOfClass:[Item class]]) {
		return NO;
	}
	
	Item *item = (Item*)that;
	
return self.identifier = item.identifier;
}

@end
