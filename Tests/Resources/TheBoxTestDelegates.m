/*
 *  Copyright 2010 TheBox
 *  All rights reserved.
 *
 *  This file is part of TheBox
 *
 *  Created by Markos Charatzas <[firstname.lastname@gmail.com]> on 25/03/2011.
 *  Contributor(s): .-
 */
#import "TheBoxTestDelegates.h"
#import "TheBoxDelegate.h"
#import "TheBoxQuery.h"

/*
 * Holds a buffer of all response strings as pass via TheBoxDelegateLogger#query:ok:
 * Calling TheBoxDelegateLogger#description will return the buffer
 */
@implementation TheBoxDelegateLogger

NSMutableString *buffer;

-(id) init
{
	self = [super init];
	
	if (self) {
		buffer = [[NSMutableString alloc] init];
	}
return self;
}

- (void)query:(id<TheBoxQuery>)query ok:(NSString *)response{
	[buffer appendString:response];
}

-(NSString *) description{
return buffer;
}

@end

@implementation TheBoxTestDelegates

/*
 * @return a TheBoxDelegate implementation that logs all method calls
 */
+(TheBoxDelegateLogger*) newLoggingDelegate{
return [[TheBoxDelegateLogger alloc] init];
}
@end
