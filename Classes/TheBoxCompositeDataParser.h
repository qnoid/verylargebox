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
#import "TheBoxDataParser.h"

@interface TheBoxCompositeDataParser : NSObject <TheBoxDataParser>
{
	@private
		id<TheBoxDataParserDelegate> delegate;
}

@property(nonatomic, assign) id<TheBoxDataParserDelegate> delegate;

-(void)parse:(NSDictionary *) data;

@end
