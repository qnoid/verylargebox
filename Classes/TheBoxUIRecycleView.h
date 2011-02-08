//
//  TheBoxUIRecycleView.h
//  TheBox
//
//  Created by Markos Charatzas on 07/02/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VisibleStrategy.h"
@class TheBoxUIRecycleStrategy;
@class VisibleStrategy;


@interface TheBoxUIRecycleView : UIView 
{
	
	@private
		TheBoxUIRecycleStrategy *recycleStrategy;
		id<VisibleStrategy> visibleStrategy;
}
+(TheBoxUIRecycleView *) newRecycledView:(TheBoxUIRecycleStrategy *)recycleStrategy visibleStrategy:(id<VisibleStrategy>) visibleStrategy;

@property(nonatomic, retain) TheBoxUIRecycleStrategy *recycleStrategy;
@property(nonatomic, retain) id<VisibleStrategy> visibleStrategy;


-(void) size:(CGSize) size bounds:(CGRect)bounds;
-(UIView *)dequeueReusableView;

@end
