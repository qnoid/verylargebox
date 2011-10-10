/*
 *  Copyright 2011 TheBox
 *  All rights reserved.
 *
 *  This file is part of TheBox
 *
 *  Created by Markos Charatzas <[firstname.lastname@gmail.com]> on 07/02/2011.
 *  Contributor(s): .-
 */
#import <UIKit/UIKit.h>
#import "VisibleStrategy.h"
#import "TheBoxUIScrollViewDatasource.h"
@class TheBoxUIRecycleStrategy;
@class VisibleStrategy;
@class TheBoxUIScrollView;
@class TheBoxSize;
@protocol TheBoxUIScrollViewDatasource;


@protocol TheBoxUIScrollViewDelegate 

-(CGSize)contentSizeOf:(TheBoxUIScrollView *)scrollView withData:(id<TheBoxUIScrollViewDatasource>)datasource;

@optional
- (CGFloat)whatRowHeight:(TheBoxUIScrollView *)scrollView;
@end

/*
 * An implementation of UIScrollView which recycles views and calculates visible ones.
 * Is it's own delegate
 */
@interface TheBoxUIScrollView : UIScrollView <UIScrollViewDelegate, VisibleStrategyDelegate>
{
	
	@private
		id <TheBoxUIScrollViewDatasource>  datasource;
		id <TheBoxUIScrollViewDelegate>  scrollViewDelegate;
}

+(TheBoxUIScrollView *) newVerticalScrollView:(CGRect)frame viewsOf:(CGFloat)height;
+(TheBoxUIScrollView *) newHorizontalScrollView:(CGRect)frame viewsOf:(CGFloat)width;
+(TheBoxUIScrollView *) newScrollView:(CGRect)frame recycleStrategy:(TheBoxUIRecycleStrategy *)recycleStrategy visibleStrategy:(id<VisibleStrategy>) visibleStrategy;

@property(nonatomic, assign) id <TheBoxUIScrollViewDatasource> datasource;
@property(nonatomic, assign) id <TheBoxUIScrollViewDelegate> scrollViewDelegate;
@property(nonatomic, retain) TheBoxSize *theBoxSize;

-(UIView*)dequeueReusableView;

@end
