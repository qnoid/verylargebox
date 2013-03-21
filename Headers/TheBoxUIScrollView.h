/*
 *  Copyright 2011 TheBox
 *  All rights reserved.
 *
 *  This file is part of TheBox
 *
 *  Created by Markos Charatzas (@qnoid) on 07/02/2011.
 *  Contributor(s): .-
 */
#import "VisibleStrategy.h"
#import "TheBoxUIScrollViewDatasource.h"
#import "CanIndexLocationInView.h"
@class TheBoxUIRecycleStrategy;
@class VisibleStrategy;
@class TheBoxUIScrollView;
@class TheBoxSize;
@protocol TheBoxUIScrollViewDatasource;
@protocol TheBoxDimension;

typedef void(^TBUIScrollViewConfig)(TheBoxUIScrollView *scrollView, BOOL cancelsTouchesInView);

extern CGFloat const DEFAULT_HEIGHT;
extern TBUIScrollViewConfig const TBUIScrollViewAllowSelection;

@protocol TheBoxUIScrollViewDelegate

/**
 Will get a callback if #setNeedsLayout has been called on the next #layoutSubviews.
 
 @param scrollView the TheBoxUIScrollView associated with the delegate
 */
-(void)didLayoutSubviews:(UIScrollView*)scrollView;

/**
 Implementations should customise the appearance of the view.
 
 The view might be a recycled view or a new instance.
 
 @param scrollView the TheBoxUIScrollView associated with the delegate
 @param view the UIView subclass as returned by the TheBoxUIScrollViewDatasource#viewInScrollView:ofFrame:atIndex:
 @param the index of the view that will appear
 */
- (void)viewInScrollView:(TheBoxUIScrollView *)scrollView willAppear:(UIView *)view atIndex:(NSUInteger)index;

/**
 @param scrollView the TheBoxUIScrollView associated with the delegate
 @param minimumVisibleIndex the minimum index of the view that will appear in the next cycle
 @param maximumVisibleIndex the maximum index of the view that will appear in the next cycle
 @see viewInScrollView:willAppear:atIndex:
 */
- (void)viewInScrollView:(TheBoxUIScrollView *)scrollView willAppearBetween:(NSUInteger)minimumVisibleIndex to:(NSUInteger)maximumVisibleIndex;

/**
 @param scrollView the TheBoxUIScrollView associated with the delegate
 @param index the index at which the scrollView will come at a stop
 */
-(void)scrollView:(UIScrollView *)scrollView willStopAt:(NSUInteger)index;

@optional
- (void)didSelectView:(TheBoxUIScrollView *)scrollView atIndex:(NSUInteger)index point:(CGPoint)point;

#pragma when using a refresh view
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate;

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
 @see #newVerticalScrollView:viewsOf: to create a TheBoxUIScrollView scrolling on the vertical axis
 @see #newHorizontalScrollView:viewsOf: to create a TheBoxUIScrollView scrolling on the horizontal axis
 @see TheBoxUIScrollViewBuilder for optional methods
 */
@interface TheBoxUIScrollView : UIScrollView <VisibleStrategyDelegate, CanIndexLocationInView, UIScrollViewDelegate>

/**
 Creates a new scroll view which scrolls on the vertical axis.
 The width of the scrollview is based on the given frame while the height of each view shown in the scrollview is 
 
 @parameter frame the frame of the scrollview
 @parameter height the height of each view in the scrollview as returned by TheBoxUIScrollViewDatasource#viewInScrollView:atIndex:
 */
+(TheBoxUIScrollView *) newVerticalScrollView:(CGRect)frame viewsOf:(CGFloat)height;

/**
 Creates a new scroll view which scrolls on the horizontal axis.
 
 @param frame the frame of the scroll view
 @param width the width of each view in the axis the scroll view is created
 */
+(TheBoxUIScrollView *) newHorizontalScrollView:(CGRect)frame viewsOf:(CGFloat)width;

@property(nonatomic, unsafe_unretained) IBOutlet id <TheBoxUIScrollViewDatasource> datasource;
@property(nonatomic, unsafe_unretained) IBOutlet id <TheBoxUIScrollViewDelegate> scrollViewDelegate;

// the scrollview will only stop at the edge of a view.
@property(nonatomic, assign, getter = isSeekingEnabled) BOOL enableSeeking;

/**
 Call this method will recycle any subviews that where added as part of 
 TheBoxUIScrollView#viewInScrollView:atIndex: effectively removing them from this view.
 
 Any previously visible views are invalidated.
 */
-(void)setNeedsLayout;

@end

/**
  Allows user 
 */
@interface TheBoxUIScrollViewBuilder : NSObject

/**
 Creates a new TheBoxUIScrollViewBuilder that creates scrollviews with the given frame.
 
 A vertical scrollview will have its views matching in width and a height in the given dimension.
 A horizontal scrollview will have its views matching in height and a width in the given dimension.
 
 @param frame the frame of the scroll view
 @param dimension the dimension of each view in the axis the scroll view is created
 @return a new instance of TheBoxUIScrollViewBuilder
 */
- (id)initWith:(CGRect)frame viewsOf:(CGFloat)dimension;

/**
 Enables user selection by tapping in a view.
 
 @discussion @required TheBoxUIScrollViewDelegate#didSelectView:atIndex:
 */
-(TheBoxUIScrollViewBuilder*)allowSelection;

-(TheBoxUIScrollViewBuilder*)canCancelContentTouches;

-(TheBoxUIScrollView *)newVerticalScrollView;

-(TheBoxUIScrollView *)newHorizontalScrollView;
@end
