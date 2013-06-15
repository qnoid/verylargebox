//
//  Copyright 2010 The Box
//  All rights reserved.
//
//  This file is part of TheBox
//
//  Created by Markos Charatzas on 13/12/10.
//

@protocol VLBRecycleStrategyMethod <NSObject>

-(BOOL)is:(CGRect)rect visibleIn:(CGRect)bounds;

@end
