/*
 *  Copyright 2011 TheBox
 *  All rights reserved.
 *
 *  This file is part of TheBox
 *
 *  Created by Markos Charatzas (@qnoid) on 07/02/2011.
 *  Contributor(s): .-
 */
#import <UIKit/UIKit.h>
#import "VisibleStrategy.h"
#import "TheBoxUIScrollViewDatasource.h"
#import "CanDequeueReusableView.h"
#import "CanIndexLocationInView.h"
@class TheBoxUIRecycleStrategy;
@class VisibleStrategy;
@class TheBoxUIScrollView;
@class TheBoxSize;
@protocol TheBoxUIScrollViewDatasource;
@protocol TheBoxDimension;

extern CGFloat const DEFAULT_HEIGHT;

@protocol TheBoxUIScrollViewDelegate

- (void)viewInScrollView:(TheBoxUIScrollView *)scrollView willAppear:(UIView *)view atIndex:(NSUInteger)index;

@optional

/**

 */
-(UIView *)headerInScrollView:(TheBoxUIScrollView *)scrollView;
-(CGFloat)whatSize:(TheBoxUIScrollView *)scrollView;
@end

/**
 An implementation of UIScrollView which is divived mentally in many views.
 e.g. a TheBoxUIScrollView with a frame of 320x480 and contentSize of 320x588 
 divided in views of 196px will yield:
 
                320px
    -    |---------------|          -
    |    |               |          |
    |    |               |          |
    |    |               |          |
    |    |               |  196px   |
    |    |               |          |
    |    |               |          |
    |    |---------------|          |
    |    |               |          |
    |    |               |          |
 480px   |               |  196px   |
    |    |               |          |
    |    |               |         588px
    |    |               |          |
    |    |---------------|          |
    |    |               |          |
    |    |               |          |
    |    |               |          |
    -    |               |  196px   |
         |               |          |
         |               |          |
         |---------------|          _
 
 
 Preconditions to use TheBoxUIScrollView is to assign a datasource and a delegate and implement their required methods.
 
 TheBoxUIScrollView will calculate its contentSize based on the number of views as returned by 
 TheBoxUIScrollViewDatasource#numberOfViewsInScrollView:
 
 TheBoxUIScrollView will lazy query (TheBoxUIScrollViewDatasource#viewOf:atIndex:) for a view at the "point" where it becomes visible 
 and will "recycle" it as it scrolls past its bounds. Each subsequent pass through will query for the view again.
 
 TheBoxUIScrollView will handle bounces of the scrollview gracefully. 
 
 To use TheBoxUIScrollView in IB, drag a UIScrollView, change its type to TheBoxUIScrollView and set its datasource and scrollViewDelegate IBOutlets.
 The **default** TheBoxUIScrollView scrolls on the vertical axis and with views of 196px in height.
 
 To programmatically create one, use one of the following factory methods 
 @see #newVerticalScrollView:viewsOf: to create a TheBoxUIScrollView on the vertical axis
 @see #newHorizontalScrollView:viewsOf: to create a TheBoxUIScrollView on the horizontal axis
 */
@interface TheBoxUIScrollView : UIScrollView <VisibleStrategyDelegate, CanDequeueReusableView, CanIndexLocationInView>

/**
 Creates a new scroll view which scrolls on the vertical axis.
 The width of the scrollview is based on the given frame while the height of each view shown in the scrollview is 
 
 @parameter frame the frame of the scrollview
 @parameter height the height of each view in the scrollview as returned by TheBoxUIScrollViewDatasource#viewInScrollView:atIndex:
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

@end
