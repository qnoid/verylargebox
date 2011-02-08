/*
 *  Copyright 2010 The Box
 *  All rights reserved.
 *
 *  This file is part of TheBox
 *
 *  Created by Markos Charatzas <[firstname.lastname@gmail.com]> on 13/12/10.
 *  Contributor(s): .-
 */
#import <CoreGraphics/CGGeometry.h>


@protocol TheBoxUIRecycleStrategyMethod <NSObject>

-(BOOL)is:(CGRect)rect visibleIn:(CGRect)bounds;

@end
