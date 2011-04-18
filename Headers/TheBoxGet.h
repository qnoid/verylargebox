/*
 *  Copyright 2010 TheBox
 *  All rights reserved.
 *
 *  This file is part of TheBox
 *
 *  Created by Markos Charatzas <[firstname.lastname@gmail.com]> on 20/03/2011.
 *  Contributor(s): .-
 */
#import <Foundation/Foundation.h>
#import "TheBoxQuery.h"
#import "ASIHTTPRequestDelegate.h"
@class ASIHTTPRequest;
@class TheBoxDelegateHandler;


@interface TheBoxGet : NSObject <TheBoxQuery, ASIHTTPRequestDelegate> 
{
	@private
		ASIHTTPRequest *request;
}

@property(nonatomic, retain) TheBoxDelegateHandler *handler;
@property(nonatomic, retain) ASIHTTPRequest *request;

-(id)initWithRequest:(ASIHTTPRequest*) request;

-(void)make:(id<TheBoxDelegate>)theDelegate;

@end
