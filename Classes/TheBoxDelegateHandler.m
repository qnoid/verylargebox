/*
 *  Copyright 2010 TheBox
 *  All rights reserved.
 *
 *  This file is part of TheBox
 *
 *  Created by Markos Charatzas <[firstname.lastname@gmail.com]> on 25/03/2011.
 *  Contributor(s): .-
 */
#import "TheBoxDelegateHandler.h"
#import "TheBoxDelegate.h"
#import "ASIHTTPRequest.h"

/*
 * In both TheBoxPost#make and TheBoxGet#make implementations you need to keep a 
 * reference to the TheBoxDelegate to callback on 
 *
 * ASIHTTPRequestDelegate#requestFinished
 * ASIHTTPRequestDelegate#requestFailed
 */
@implementation TheBoxDelegateHandler

@synthesize delegate;

- (void)query:(id<TheBoxQuery>)query ok:(NSString *)response
{
	[self.delegate query: query ok:response];
}

- (void)query:(id<TheBoxQuery>)query failed:(NSString *)response
{
	NSLog(@"query: %@ failed: %@", query, response);
}

@end
