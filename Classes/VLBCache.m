/*
 *  Copyright 2010 TheBox
 *  All rights reserved.
 *
 *  This file is part of TheBox
 *
 *  Created by Markos Charatzas (@qnoid) on 25/03/2011.
 *  Contributor(s): .-
 */
#import "VLBCache.h"


@implementation VLBCache

@synthesize cache;

- (id) init
{
	self = [super init];
	
	if (self) 
	{
		self.cache = [[NSCache alloc] init];
        
	}
return self;
}

-(void)setObject:(id)anObject forKey:(id)aKey
{
	[self.cache setObject:anObject forKey:aKey];
}

-(id)objectForKey:(id)key {
return [self.cache objectForKey:key];
}

@end