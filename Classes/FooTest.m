/*
 *  Copyright 2010 TheBox
 *  All rights reserved.
 *
 *  This file is part of TheBox
 *
 *  Created by Markos Charatzas <[firstname.lastname@gmail.com]> on 27/02/2011.
 *  Contributor(s): .-
 */
#import "FooTest.h"


@implementation FooTest

+(ASIHTTPRequest *)jsonRequest:(NSString *)url
{
	NSURL *itemsEndPoint = [NSURL URLWithString:url];
	ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:itemsEndPoint];
	[request addRequestHeader:@"Accept" value:@"application/json"];	
return request;
}

@end
