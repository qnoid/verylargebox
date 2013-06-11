/*
 *  Copyright 2013 TheBox
 *  All rights reserved.
 *
 *  This file is part of thebox
 *
 *  Created by Markos Charatzas (___twitter___) 30/05/2013.
 *  Contributor(s): .-
 */
#import "TBViews.h"

@implementation TBViews

+(TBViewContext) fill:(UIColor*) fill
{
    return ^(TBViewDrawContext drawContext){
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(context, fill.CGColor);
        
        drawContext(context);
        
        CGContextClosePath(context);
        CGContextDrawPath(context, kCGPathFill);
        UIGraphicsEndImageContext();
    };
}

+(TBViewContext) stroke:(UIColor*) stroke
{
    return ^(TBViewDrawContext drawContext){
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetLineWidth(context, 2.0f);
        CGContextSetStrokeColorWithColor(context, stroke.CGColor);
        
        drawContext(context);
        
        CGContextClosePath(context);
        CGContextDrawPath(context, kCGPathStroke);
        UIGraphicsEndImageContext();
    };
}


+(TBViewContext) solidContext:(UIColor*) fill stroke:(UIColor*) stroke
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

@end
