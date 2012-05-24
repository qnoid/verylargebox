/*
 *  Copyright 2010 The Box
 *  All rights reserved.
 *
 *  This file is part of TheBox
 *
 *  Created by Markos Charatzas (@qnoid) on 13/12/10.
 *  Contributor(s): .-
 */
#import <Foundation/Foundation.h>
#import <CoreGraphics/CGGeometry.h>

CG_INLINE
CGRect TBCGRectDiff(CGRect rect1, CGRect rect2){
    return CGRectMake(
                      abs(rect1.origin.x), 
                      abs(rect1.origin.y + rect2.size.height), 
                      rect1.size.width, 
                      rect1.size.height);
}

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

/*
 * Calculates the frame required given the index
 *
 * @param index the index of the frame
 * 
 * @return a CGRect representing the frame
 */
-(CGRect) frame:(NSUInteger)index minimumWidth:(CGFloat) width;

-(CGRect) frame:(NSUInteger)index minimumHeight:(CGFloat) height;

@end
