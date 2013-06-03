//
//  TBDrawRects.h
//  thebox
//
//  Created by Markos Charatzas on 02/06/2013.
//  Copyright (c) 2013 TheBox. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TBViews.h"

@class TBPolygon;

@interface TBDrawRects : NSObject

-(TBViewDrawContext)drawContextOfHexagon:(TBPolygon*)hexagon;
-(void)drawContextOfHexagonInRect:(CGRect) rect;

@end
