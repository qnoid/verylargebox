/*
 *  Copyright 2010 TheBox
 *  All rights reserved.
 *
 *  This file is part of TheBox
 *
 *  Created by Markos Charatzas <[firstname.lastname@gmail.com]> on 20/03/2011.
 *  Contributor(s): .-
 */
#import "TheBoxPost.h"
#import "ASIFormDataRequest.h"
#import "TheBoxDelegateHandler.h"

@implementation TheBoxPost

@synthesize handler;
@synthesize request;

- (void) dealloc
{
	[handler release];
	[request release];
	[super dealloc];
}


-(id)initWithRequest:(ASIFormDataRequest *) theRequest
{
	self = [super init];
	
	if (self) 
    {
        TheBoxDelegateHandler* delegateHandler = [[TheBoxDelegateHandler alloc] init];
        
		self.request = theRequest;
        
		self.handler = delegateHandler;
        
        [delegateHandler release];
	}
	
return self;
}

-(void)make:(id<TheBoxDelegate>)theDelegate
{
	self.request.delegate = self;	
	self.handler.delegate = theDelegate;
	[self.request startAsynchronous];	
}

- (void)requestFinished:(ASIHTTPRequest *)theRequest {
	[self.handler query:self ok:[theRequest responseString]];
}
- (void)requestFailed:(ASIHTTPRequest *)theRequest {
	[self.handler query:self failed:[theRequest responseString]];
}

-(NSUInteger)hash{
return self.request.url.hash;
}

-(BOOL) isEqual:(id)that
{
	if (self == that) {
		return YES;
	}
	
	if (![that isKindOfClass:[TheBoxPost class]]) {
		return NO;
	}
	
	TheBoxPost* query = (TheBoxPost*)that;
	
return [self.request.url isEqual:query.request.url];
}

-(NSString *) description{
return [self.request description];
}


@end
