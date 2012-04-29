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
@protocol TheBoxDimension;

@protocol TheBoxUIScrollViewDelegate 

/**
 
 @param view as returned by TheBoxUIScrollViewDatasource#viewInScrollView:atIndex
 */
-(void)viewInScrollView:(TheBoxUIScrollView *)scrollView atIndex:(NSUInteger)index willAppear:(UIView*)view;

@optional
-(CGFloat)whatSize:(TheBoxUIScrollView *)scrollView;
@end

/**
 An implementation of UIScrollView which recycles views and calculates visible ones.
 
 A datasource must be set which must return the number of views in the scrollview (TheBoxUIScrollViewDatasource#numberOfViews:) 
 and will be queried for the view to show (TheBoxUIScrollViewDatasource#viewOf:atIndex:)
 
 The datasource will be asked for a view as it becomes visible.
 
 @see #newVerticalScrollView:viewsOf:
 @see #newHorizontalScrollView:viewsOf:
 */
@interface TheBoxUIScrollView : UIScrollView <VisibleStrategyDelegate>

/**
 Creates a new scroll view which scrolls on the vertical axis
 
 @parameter frame
 */
+(TheBoxUIScrollView *) newVerticalScrollView:(CGRect)frame viewsOf:(CGFloat)height;

/**
 Creates a new scroll view which scrolls on the horizontal axis
 
 @parameter frame
 */
+(TheBoxUIScrollView *) newHorizontalScrollView:(CGRect)frame viewsOf:(CGFloat)width;

@property(nonatomic, unsafe_unretained) IBOutlet id <TheBoxUIScrollViewDatasource> datasource;
@property(nonatomic, unsafe_unretained) IBOutlet id <TheBoxUIScrollViewDelegate> scrollViewDelegate;

/**
 Call this method will recycle any subviews that where added as part of 
 TheBoxUIScrollView#viewInScrollView:atIndex: effectively removing them from this view.
 
 Any previously visible views are invalidated.
 */
-(void)setNeedsLayout;
-(UIView*)dequeueReusableView;
-(NSUInteger)indexOf:(CGPoint)point;
@end
