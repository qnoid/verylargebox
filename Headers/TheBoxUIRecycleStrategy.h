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

/*
 * Use this class to recycle views that go outside of given bounds
 *
 * @see recycle:bounds
 *
 */
@interface TheBoxUIRecycleStrategy : NSObject
{
	@private
		NSMutableSet *recycledViews;
		id<TheBoxUIRecycleStrategyMethod>	recycleMethod;
}

@property(nonatomic, retain) NSMutableSet *recycledViews;
@property(nonatomic, retain) id<TheBoxUIRecycleStrategyMethod> recycleMethod;

/*
 * @return a new TheBoxUIRecycleStrategy that recycles views partially visible on the X
 */
+(TheBoxUIRecycleStrategy *)newPartiallyVisibleWithinX;

/*
 * @return a new TheBoxUIRecycleStrategy that recycles views partially visible on the Y
 */
+(TheBoxUIRecycleStrategy *)newPartiallyVisibleWithinY;

-(id)initWith:(id<TheBoxUIRecycleStrategyMethod>) recycleMethod;

/*
 * Any view from the array that is not within the specified bounds will be placed
 * in the recycled views and subsequently removed from the it's superview
 *
 * @param the subviews to recycle
 * @param the visible bounds
 */
-(void)recycle:(NSArray *)views bounds:(CGRect) bounds;

/*
 * Returns a UIView from the recycled views. The UIView is not guarranteed to be in any specific state.
 * The caller needs to make sure that any relevant state is configured.
 *
 * e.g.
 *	frame
 *	contentSize
 *
 * @return a view
 */
-(UIView *)dequeueReusableView;

@end
