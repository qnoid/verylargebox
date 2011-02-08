/*
 *  Copyright 2010 The Box
 *  All rights reserved.
 *
 *  This file is part of TheBox
 *
 *  Created by Markos Charatzas <[firstname.lastname@gmail.com]> on 27/11/10.
 *  Contributor(s): .-
 */

#import <UIKit/UIKit.h>
#import "TheBoxUIRecycleStrategyMethod.h"

@interface TheBoxUIRecycleStrategy : NSObject
{
	@private
		NSMutableSet *recycledViews;
		id<TheBoxUIRecycleStrategyMethod>	recycleMethod;
}

@property(nonatomic, retain) NSMutableSet *recycledViews;
@property(nonatomic, retain) id<TheBoxUIRecycleStrategyMethod> recycleMethod;

+(TheBoxUIRecycleStrategy *)newPartiallyVisibleWithinX;
+(TheBoxUIRecycleStrategy *)newPartiallyVisibleWithinY;

-(id)initWith:(id<TheBoxUIRecycleStrategyMethod>) recycleMethod;

/**
 * Any view from the array that is not within the specified bounds will be placed
 * in the recycled views and subsequently removed from the it's superview
 *
 * @param view the UIView
 * @param the subviews to recycle
 * @param the visible bounds
 */
-(void)recycle:(UIView *)view views:(NSArray *)views bounds:(CGRect) bounds;

-(UIView *)dequeueReusableView;

@end
