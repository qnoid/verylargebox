//
//  VLBDrawRects.h
//  thebox
//
//  Created by Markos Charatzas on 02/06/2013.
//  Copyright (c) 2013 TheBox. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VLBViews.h"

@class VLBPolygon;

@interface VLBDrawRects : NSObject

-(VLBViewDrawContext)drawContextOfHexagon:(VLBPolygon *)hexagon;
-(void)drawContextOfHexagonInRect:(CGRect) rect;

@end