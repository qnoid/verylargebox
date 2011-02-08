/*
 *  Copyright 2010 The Box
 *  All rights reserved.
 *
 *  This file is part of TheBox
 *
 *  Created by Markos Charatzas <[firstname.lastname@gmail.com]> on 13/12/10.
 *  Contributor(s): .-
 */
#import "PartiallyVisibleWithinY.h"
#import "TheBoxRect.h"

@implementation PartiallyVisibleWithinY

-(BOOL)is:(CGRect)rect visibleIn:(CGRect)bounds
{	
	TheBoxRect *theRect = [[TheBoxRect alloc] initWithFrame:rect];
	BOOL isVisible = [theRect isPartiallyVisibleWithinY:bounds];
	[theRect release];
	
return isVisible;
}

@end
