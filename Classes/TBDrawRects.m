//
//  TBDrawRects.m
//  thebox
//
//  Created by Markos Charatzas on 02/06/2013.
//  Copyright (c) 2013 TheBox. All rights reserved.
//

#import "TBDrawRects.h"
#import "TBPolygon.h"
#import "TBColors.h"

@implementation TBDrawRects

-(TBViewDrawContext)drawContextOfHexagon:(TBPolygon*)hexagon
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

-(TBViewDrawContext)drawContextOfHexagonn:(TBPolygon*)hexagon
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
    TBViewContext viewContext = [TBViews solidContext:[TBColors colorDarkGrey] stroke:[UIColor blackColor]];
    
    viewContext([self drawContextOfHexagon:[TBPolygon hexagonAt:CGRectCenter(rect)]]);
}
@end
