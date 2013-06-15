//
//  Copyright (c) 2010 (verylargebox.com). All rights reserved.
//  All rights reserved.
//
//  This file is part of TheBox
//
//  Created by Markos Charatzas on 25/03/2011.
//
//

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
