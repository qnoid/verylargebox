/*
 *  Copyright 2010 TheBox
 *  All rights reserved.
 *
 *  This file is part of TheBox
 *
 *  Created by Markos Charatzas <[firstname.lastname@gmail.com]> on 26/03/2011.
 *  Contributor(s): .-
 */
#import <Foundation/Foundation.h>
#import "TheBoxDataParserDelegate.h"

@interface TheBoxDataParserDelegateLogger : NSObject <TheBoxDataParserDelegate> 
{
} 
-(id) initWithCapacity:(NSUInteger)numItems;
-(NSMutableArray*) items;
@end

@interface TheBoxDataParserTestDelegates : NSObject {
	
}

+(TheBoxDataParserDelegateLogger*) newLoggingDelegate:(NSUInteger)numItems;

@end
