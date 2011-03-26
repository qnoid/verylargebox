/*
 *  Copyright 2010 TheBox
 *  All rights reserved.
 *
 *  This file is part of TheBox
 *
 *  Created by Markos Charatzas <[firstname.lastname@gmail.com]> on 26/03/2011.
 *  Contributor(s): .-
 */
#import "TheBoxDataParserTestDelegates.h"

@implementation TheBoxDataParserDelegateLogger

NSMutableArray *items;

-(id) initWithCapacity:(NSUInteger)numItems
{
	self = [super init];
	
	if (self) {
		items = [[NSMutableArray alloc] initWithCapacity:numItems];
	}
return self;
}

- (void)element:(NSInteger)theId with:(NSDictionary *)data {
	NSLog(@"%d, %@", theId, data);
	[items insertObject:data atIndex:theId];
}

-(NSMutableArray*) items{
return items;
}

@end


@implementation TheBoxDataParserTestDelegates

+(TheBoxDataParserDelegateLogger*) newLoggingDelegate:(NSUInteger)numItems {
return [[TheBoxDataParserDelegateLogger alloc] initWithCapacity:numItems];
}

@end
