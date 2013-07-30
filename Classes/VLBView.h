//
// Copyright 2010 The Box
// All rights reserved.
//
// This file is part of thebox
//
// Created by Markos Charatzas on 19/05/2012.
//
//

#import <UIKit/UIKit.h>
#import "VLBScrollView.h"

typedef void(^VLBViewDrawRect)(CGRect rect, UIView* view);

/**
 Implementations of this protocol provide a custom drawRect method.
 
 @param rect the rect as passed in UIView#drawRect:
 @param view the view that was created with this
 
 @see UIView#drawRect:
 */
@protocol VLBViewDrawRectDelegate <NSObject>
- (void)drawRect:(CGRect)rect inView:(UIView*)view;
@end

/**
 Groups related vlb_border properties together and allows chaining.
 */
@protocol VLBViewBorder

/**
 Sets the border width
 
 @param width the vlb_border width
 @return self for chaining
 @see CALayer#borderWidth
 */
-(id<VLBViewBorder>)vlb_borderWidth:(CGFloat)width;

/**
 Sets the border color
 
 @param color the vlb_border color
 @return self for chaining
 @see CALayer#borderColor
 */
-(id<VLBViewBorder>)vlb_borderColor:(CGColorRef)color;

/**
 Access to common properties related to the border
 
 default border width 1.0f
 default border color black
 
 @return a TBButtonBorder type to set any vlb_border properties
 */
-(id<VLBViewBorder>)vlb_border;

-(id<VLBViewBorder>)vlb_topBorder:(UIColor*)color;

-(id<VLBViewBorder>)vlb_bottomBorder:(UIColor*)color height:(CGFloat)height;

- (id<VLBViewBorder>)vlb_borders:(UIColor*)color;

@end

@protocol VLBViewCorner
/**
 Sets the corner radius
 
 @param cornerRadius the corner radius
 @return self for chaining
 @see CALayer#cornerRadius
 */
-(id<VLBViewCorner>)vlb_cornerRadius:(CGFloat)cornerRadius;

//http://stackoverflow.com/questions/10167266/how-to-set-cornerradius-for-only-top-left-and-top-right-corner-of-a-uiview
-(id<VLBViewCorner>)vlb_cornerRadius:(CGFloat)cornerRadius corners:(UIRectCorner)corners;

@end

/**
 Implementation that want to provide custom drawing.
 Set the delegate property.
 
 */
@protocol VLBView <VLBViewBorder, VLBViewCorner>

@end

@interface UIView (VLBView) <VLBView>

@end

/**
 */
@interface VLBView : UIView
@end
