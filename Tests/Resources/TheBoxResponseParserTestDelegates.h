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
#import "TheBoxResponseParserDelegate.h"

@interface TheBoxResponseDelegateLogger : NSObject <TheBoxResponseParserDelegate> 
{
} 
-(NSDictionary *) data;
@end

@interface TheBoxResponseParserTestDelegates : NSObject {

}

+(TheBoxResponseDelegateLogger*) newLoggingDelegate;

@end
