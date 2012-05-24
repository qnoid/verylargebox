/*
 *  Copyright 2010 The Box
 *  All rights reserved.
 *
 *  This file is part of TheBox
 *
 *  Created by Markos Charatzas (@qnoid) on 13/12/10.
 *  Contributor(s): .-
 */
#import "TheBoxRect.h"

@interface TheBoxRect ()
-(BOOL)isWithinXorigin:(CGRect) visibleBounds;
-(BOOL)isWithinYorigin:(CGRect) visibleBounds;
-(BOOL)isWithinWidth:(CGRect) visibleBounds;
-(BOOL)isWithinHeight:(CGRect) visibleBounds;
@end


@implementation TheBoxRect

@synthesize frame;

-(id)initWithFrame:(CGRect) theFrame
{
	self = [super init];
	
	if (self) {
		self.frame = theFrame;
	}
	
return self;
}

/*
 * To be visible within the 'x' origin the calculated width from its 'x' must be 
 * greater or equal than the visible bounds 'x'
 *
 *	e.g.
 *		0	width  320
 *		xxxxxxxxxxx--------
 *		xInvisiblex|Visible
 *		xxxxxxxxxxx--------
 *
 *	0 + width >= 320
 */
-(BOOL)isWithinXorigin:(CGRect) visibleBounds {
return self.frame.origin.x + self.frame.size.width > visibleBounds.origin.x;
}

-(BOOL)isWithinYorigin:(CGRect) visibleBounds {
return self.frame.origin.y + self.frame.size.height > visibleBounds.origin.y;
}

-(BOOL)isWithinWidth:(CGRect) visibleBounds {
return (self.frame.origin.x + self.frame.size.width) < visibleBounds.size.width;
}

-(BOOL)isWithinHeight:(CGRect) visibleBounds {
return (self.frame.origin.y + self.frame.size.height) < visibleBounds.size.height;
}

-(BOOL) isVisibleWithinX:(CGRect) visibleBounds {
return [self isWithinXorigin:visibleBounds] && [self isWithinWidth:visibleBounds];
}

-(BOOL) isVisibleWithinY:(CGRect) visibleBounds {
return [self isWithinYorigin:visibleBounds] && [self isWithinHeight:visibleBounds];
}

-(BOOL)isVisible:(CGRect) visibleBounds {
return [self isVisibleWithinX:visibleBounds] && [self isVisibleWithinY:visibleBounds];
}

-(BOOL)isPartiallyVisibleWithinX:(CGRect) visibleBounds {
return [self isWithinXorigin:visibleBounds];
}

-(BOOL)isPartiallyVisibleWithinY:(CGRect) visibleBounds {
return [self isWithinYorigin:visibleBounds];
}

-(BOOL)isPartiallyVisible:(CGRect) visibleBounds {
return [self isPartiallyVisibleWithinX:visibleBounds] && [self isPartiallyVisibleWithinY:visibleBounds];
}

-(CGRect) frame:(NSUInteger)index minimumWidth:(CGFloat) width {
return CGRectMake(
			self.frame.origin.x, 
			self.frame.size.height * index, 
			MIN(width, self.frame.size.width), 
			self.frame.size.height);	
}

-(CGRect) frame:(NSUInteger)index minimumHeight:(CGFloat) height {
return CGRectMake(
			  self.frame.size.width * index, 
			  self.frame.origin.y, 
			  self.frame.size.width, 
			  MIN(height, self.frame.size.height));	
}


@end
