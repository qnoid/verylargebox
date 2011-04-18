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
@class TheBoxCompositeDataParser;

@interface TheBoxResponseParser : NSObject <TheBoxResponseParserDelegate>
{
	@private
		id<TheBoxResponseParserDelegate> delegate;
}

@property(nonatomic, assign) id<TheBoxResponseParserDelegate> delegate;


-(id)initWithDataParser:(TheBoxCompositeDataParser*) dataParser;
-(void)parse:(NSString *) response;

@end
