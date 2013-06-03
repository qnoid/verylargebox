//
//  TBViewControllers.h
//  thebox
//
//  Created by Markos Charatzas on 02/06/2013.
//  Copyright (c) 2013 TheBox. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TBViewControllers <NSObject>

@end
CGPoint center = CGRectCenter(rect);
TBPolygon* hexagon = [TBPolygon hexagonAt:center];

tbViewSolidContext([TBColors colorLightGreen], [TBColors colorDarkGreen])(^(CGContextRef context){
    [hexagon rotateAt:0.25 collect:^(int index, CGPoint angle) {
        if(index == 0){
            CGContextMoveToPoint(context, angle.x, angle.y);
        }
        
        CGContextAddLineToPoint(context, angle.x, angle.y);
    }];
});
