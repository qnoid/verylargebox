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

typedef void(^TBViewDrawContext)(CGContextRef context);
typedef void(^TBViewContext)(TBViewDrawContext drawContext);


NS_INLINE
CGPoint CGRectCenter(CGRect rect) {
    return CGPointMake(rect.size.width / 2.0, rect.size.height / 2.0);
}

NS_INLINE
TBViewContext tbViewSolidContext(UIColor *fill, UIColor *stroke)
{
    return ^(TBViewDrawContext drawContext){
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetLineWidth(context, 2.0f);
        CGContextSetFillColorWithColor(context, fill.CGColor);
        CGContextSetStrokeColorWithColor(context, stroke.CGColor);
        
        drawContext(context);
        
        CGContextClosePath(context);
        CGContextDrawPath(context, kCGPathFillStroke);
        UIGraphicsEndImageContext();
    };
}

@interface TBViews : NSObject

@end
