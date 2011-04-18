//
//  TheBoxUIRecycleView.h
//  TheBox
//
//  Created by Markos Charatzas on 07/02/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VisibleStrategy.h"
@class TheBoxUIRecycleStrategy;
@class VisibleStrategy;


/*
 * An implementation of UIScrollViewDelegate which recycles views and calculates visible ones.
 * Can also be used as a content view for a UIScrollView.
 */
@interface TheBoxUIScrollViewDelegate : UIView <UIScrollViewDelegate>
{
	
	@private
		TheBoxUIRecycleStrategy *recycleStrategy;
		id<VisibleStrategy> visibleStrategy;
}
+(TheBoxUIScrollViewDelegate *) newScrollView:(CGRect)frame recycleStrategy:(TheBoxUIRecycleStrategy *)recycleStrategy visibleStrategy:(id<VisibleStrategy>) visibleStrategy;

@property(nonatomic, retain) TheBoxUIRecycleStrategy *recycleStrategy;
@property(nonatomic, retain) id<VisibleStrategy> visibleStrategy;


-(UIView*)dequeueReusableView;

@end
