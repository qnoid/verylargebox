/*
 *  Copyright 2013 TheBox
 *  All rights reserved.
 *
 *  This file is part of thebox
 *
 *  Created by Markos Charatzas (___twitter___) 30/05/2013.
 *  Contributor(s): .-
 */
#import <Foundation/Foundation.h>

/**
 Blocks of this type will get a callback with the 
 
 @param context the context to draw at
 @see VLBViewContext
 */
typedef void(^VLBViewDrawContext)(CGContextRef context);

/**
 A view context block provides boundaries to draw to a context.

 @param drawContext the block to pass the context to draw at
 @see VLBViews#solidContext:stroke
 */
typedef void(^VLBViewContext)(VLBViewDrawContext drawContext);


NS_INLINE
CGPoint CGRectCenter(CGRect rect) {
    return CGPointMake(rect.size.width / 2.0, rect.size.height / 2.0);
}

@interface VLBViews : NSObject


+(VLBViewContext) fill:(UIColor*) fill;

/**
 A VLBViewContext to draw a stroked graphic in the current context.
 
 @param stroke the stroke color to use
 @return a VLBViewContext based on the current context as returned by UIGraphicsGetCurrentContext
 @see CGContextSetFillColorWithColor
 @see CGContextSetStrokeColorWithColor
 */
+(VLBViewContext) stroke:(UIColor*) stroke;

/**
 A VLBViewContext to draw a filled, stroked graphic in the current context.
 
 @param fill the fill color to use
 @param stroke the stroke color to use
 @return a VLBViewContext based on the current context as returned by UIGraphicsGetCurrentContext
 @see CGContextSetFillColorWithColor
 @see CGContextSetStrokeColorWithColor
 */
+(VLBViewContext) solidContext:(UIColor*) fill stroke:(UIColor*) stroke;

@end
