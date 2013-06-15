//
//  Copyright 2013 TheBox
//  All rights reserved.
//
//  This file is part of thebox
//
//  Created by Markos Charatzas on 30/05/2013.
//
//

#import "VLBViews.h"

@implementation VLBViews

+(VLBViewContext) fill:(UIColor*) fill
{
    return ^(VLBViewDrawContext drawContext){
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(context, fill.CGColor);
        
        drawContext(context);
        
        CGContextClosePath(context);
        CGContextDrawPath(context, kCGPathFill);
        UIGraphicsEndImageContext();
    };
}

+(VLBViewContext) stroke:(UIColor*) stroke
{
    return ^(VLBViewDrawContext drawContext){
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetLineWidth(context, 2.0f);
        CGContextSetStrokeColorWithColor(context, stroke.CGColor);
        
        drawContext(context);
        
        CGContextClosePath(context);
        CGContextDrawPath(context, kCGPathStroke);
        UIGraphicsEndImageContext();
    };
}


+(VLBViewContext) solidContext:(UIColor*) fill stroke:(UIColor*) stroke
{
    return ^(VLBViewDrawContext drawContext){
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
