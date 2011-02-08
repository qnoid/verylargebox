/*
 *  Copyright 2010 The Box
 *  All rights reserved.
 *
 *  This file is part of TheBox
 *
 *  Created by Markos Charatzas <[firstname.lastname@gmail.com]> on 13/12/10.
 *  Contributor(s): .-
 */
#import <Foundation/Foundation.h>
#import <CoreGraphics/CGGeometry.h>

@interface TheBoxRect : NSObject 
{
	@private
		CGRect frame;
}

@property(nonatomic, assign) CGRect frame;

-(id)initWithFrame:(CGRect) frame;
/*
 * Return true if visible within both x and y
 */
-(BOOL)isVisible:(CGRect) visibleBounds;

/*
 * Return true even if partially visible within both x and y
 */
-(BOOL)isPartiallyVisible:(CGRect) visibleBounds;

-(BOOL)isPartiallyVisibleWithinX:(CGRect) visibleBounds;
-(BOOL)isPartiallyVisibleWithinY:(CGRect) visibleBounds;

-(BOOL)isVisibleWithinX:(CGRect) visibleBounds;
-(BOOL)isVisibleWithinY:(CGRect) visibleBounds;

@end
