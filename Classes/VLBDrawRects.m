//
//  VLBDrawRects.m
//  thebox
//
//  Created by Markos Charatzas on 02/06/2013.
//  Copyright (c) 2013 (verylargebox.com). All rights reserved.
//

#import "VLBDrawRects.h"
#import "VLBPolygon.h"
#import "VLBColors.h"

@implementation VLBDrawRects

-(VLBViewDrawContext)drawContextOfHexagon:(VLBPolygon *)hexagon
{
return ^(CGContextRef context){
        [hexagon rotateAt:0.25 collect:^(int index, CGPoint angle) {
            if(index == 0){
                CGContextMoveToPoint(context, angle.x, angle.y);
            }
            
            CGContextAddLineToPoint(context, angle.x, angle.y);
        }];
    };
}

-(VLBViewDrawContext)drawContextOfHexagonn:(VLBPolygon *)hexagon
{
    return ^(CGContextRef context){
        NSMutableArray *array = [NSMutableArray new];

        [hexagon rotateAt:0.25 collect:^(int index, CGPoint angle) {
            if(index == 0){
                CGContextMoveToPoint(context, angle.x, angle.y);
            }
            
            if(index % 2 == 0){
                [array addObject:[NSValue valueWithCGPoint:angle]];
            }
            
            CGContextAddLineToPoint(context, angle.x, angle.y);
        }];
        
        for (NSValue *v in array) {
            CGPoint p = [v CGPointValue];
            CGContextMoveToPoint(context, p.x, p.y);
            CGContextAddLineToPoint(context, hexagon.center.x, hexagon.center.y);
        }
    };
}

-(void)drawContextOfHexagonInRect:(CGRect) rect
{
    VLBViewContext context = [VLBViews fill:[VLBColors colorPrimaryBlue]];
    context([[VLBDrawRects new] drawContextOfHexagon:[VLBPolygon hexagonAt:CGRectCenter(rect)]]);
}
@end
