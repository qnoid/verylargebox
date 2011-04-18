/*
 *  Copyright 2010 TheBox
 *  All rights reserved.
 *
 *  This file is part of TheBox
 *
 *  Created by Markos Charatzas <[firstname.lastname@gmail.com]> on 02/04/2011.
 *  Contributor(s): .-
 */
#import <Foundation/Foundation.h>
#import "TheBoxDataParserDelegate.h"
#import "TheBoxDataParser.h"


@interface TheBoxSingleDataParser : NSObject <TheBoxDataParser>
{
	@private
		id<TheBoxDataParserDelegate> delegate;
}

-(void)parse:(NSDictionary *) data;

@end
