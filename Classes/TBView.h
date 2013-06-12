/*
 *  Copyright 2010 The Box
 *  All rights reserved.
 *
 *  This file is part of TheBox
 *
 *  Created by Markos Charatzas (@qnoid) on 19/05/2012.
 *  Contributor(s): .-
 */
#import <UIKit/UIKit.h>
#import "TheBoxUIScrollView.h"

typedef void(^TBViewDrawRect)(CGRect rect, UIView* view);

/**
 Implementations of this protocol provide a custom drawRect method.
 
 @param rect the rect as passed in UIView#drawRect:
 @param view the view that was created with this
 
 @see UIView#drawRect:
 */
@protocol TBViewDrawRectDelegate <NSObject>
- (void)drawRect:(CGRect)rect inView:(UIView*)view;
@end

/**
 Groups related border properties together and allows chaining.
 */
@protocol TBViewBorder

/**
 Sets the border width
 
 @param width the border width
 @return self for chaining
 @see CALayer#borderWidth
 */
-(id<TBViewBorder>)borderWidth:(CGFloat)width;

/**
 Sets the border color
 
 @param color the border color
 @return self for chaining
 @see CALayer#borderColor
 */
-(id<TBViewBorder>)borderColor:(CGColorRef)color;

/**
 Access to common properties related to the border
 
 default border width 1.0f
 default border color black
 
 @return a TBButtonBorder type to set any border properties
 */
-(id<TBViewBorder>)border;

-(id<TBViewBorder>)bottomBorder:(UIColor*)color;

- (id<TBViewBorder>)borders:(UIColor*)color;

@end

@protocol TBViewCorner
/**
 Sets the corner radius
 
 @param cornerRadius the corner radius
 @return self for chaining
 @see CALayer#cornerRadius
 */
-(id<TBViewCorner>)cornerRadius:(CGFloat)cornerRadius;

@end

/**
 Implementation that want to provide custom drawing.
 Set the delegate property.
 
 */
@protocol TBView <TBViewBorder, TBViewCorner>

@end

@interface UIView (TBView) <TBView>

@end

/**
 */
@interface TBView : UIView
@end
