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

/**
  Implementations of this protocol provide a custom drawRect method.
 
 @param rect the rect as passed in UIView#drawRect:
 @param view the view that was created with this
 
 @see UIView#drawRect:
 */
@protocol TBUIViewDrawRect <NSObject>
- (void)drawRect:(CGRect)rect onView:(UIView*)view;
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
@end


/**
 Groups related border properties together and allows chaining.
 */
@interface UIView (TBViewBorder) <TBViewBorder>

/**
 Access to common properties related to the border
 
 default border width 1.0f
 default border color black
 
 @return a TBButtonBorder type to set any border properties
 */
-(id<TBViewBorder>)border;

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
@end

/**
 A UIView that allows you to implement drawRect via composition.
 
 */
@interface TBUIView : UIView
@property(nonatomic, strong) NSObject<TBUIViewDrawRect> *drawRect;
@end
