/*
 *  Copyright 2010 TheBox
 *  All rights reserved.
 *
 *  This file is part of TheBox
 *
 *  Created by Markos Charatzas <[firstname.lastname@gmail.com]> on 26/03/2011.
 *  Contributor(s): .-
 */
#import "TheBoxResponseParserTestDelegates.h"

@implementation TheBoxResponseDelegateLogger

NSDictionary *theData;

- (void)response:(NSString*)response ok:(NSDictionary *)data{
	theData = data;
}

-(NSDictionary *) data{
return theData;
}

@end

@implementation TheBoxResponseParserTestDelegates


+(TheBoxResponseDelegateLogger*) newLoggingDelegate {
return [[TheBoxResponseDelegateLogger alloc] init];
}

@end
