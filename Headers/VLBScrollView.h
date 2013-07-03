//
//  Copyright (c) 2011 (verylargebox.com). All rights reserved.
//  All rights reserved.
//
//  This file is part of TheBox
//
//  Created by Markos Charatzas on 07/02/2011.
//
//
#import "VLBVisibleStrategy.h"
#import "VLBScrollViewDatasource.h"
#import "VLBCanIndexLocationInView.h"
@class VLBRecycleStrategy;
@class VLBVisibleStrategy;
@class VLBScrollView;
@class VLBSize;
@protocol VLBScrollViewDatasource;
@protocol VLBDimension;

typedef void(^VLBScrollViewConfig)(VLBScrollView *scrollView, BOOL cancelsTouchesInView);

extern CGFloat const DEFAULT_HEIGHT;
extern VLBScrollViewConfig const VLBScrollViewAllowSelection;

@protocol VLBScrollViewDelegate

/**
 Will get a callback if #setNeedsLayout has been called on the next #layoutSubviews.
 
 @param scrollView the VLBScrollView associated with the delegate
 */
-(void)didLayoutSubviews:(UIScrollView*)scrollView;

/**
 Implementations should customise the appearance of the view.
 
 The view might be a recycled view or a new instance.
 
 @param scrollView the VLBScrollView associated with the delegate
 @param view the UIView subclass as returned by the VLBScrollViewDatasource#viewInScrollView:ofFrame:atIndex:
 @param the index of the view that will appear
 */
- (void)viewInScrollView:(VLBScrollView *)scrollView willAppear:(UIView *)view atIndex:(NSUInteger)index;

/**
 @param scrollView the VLBScrollView associated with the delegate
 @param minimumVisibleIndex the minimum index of the view that will appear in the next cycle
 @param maximumVisibleIndex the maximum index of the view that will appear in the next cycle
 @see viewInScrollView:willAppear:atIndex:
 */
- (void)viewInScrollView:(VLBScrollView *)scrollView willAppearBetween:(NSUInteger)minimumVisibleIndex to:(NSUInteger)maximumVisibleIndex;

/**
 @param scrollView the VLBScrollView associated with the delegate
 @param index the index at which the scrollView will come at a stop
 */
-(void)scrollView:(UIScrollView *)scrollView willStopAt:(NSUInteger)index;

@optional

/**
 Implement when using IB
 */
- (CGFloat)viewsOf:(VLBScrollView *)scrollView;

- (void)didSelectView:(VLBScrollView *)scrollView atIndex:(NSUInteger)index point:(CGPoint)point;

#pragma when using a refresh view
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate;

@end

/**
 An implementation of UIScrollView which is divived mentally in many views.
 e.g. a VLBScrollView with a frame of 320x480 and contentSize of 320x588
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
 
 
 Preconditions to use VLBScrollView is to assign a datasource and a delegate and implement their required methods.
 
 VLBScrollView will calculate its contentSize based on the number of views as returned by
 VLBScrollViewDatasource#numberOfViewsInScrollView:
 
 VLBScrollView will lazy query (VLBScrollViewDatasource#viewOf:atIndex:) for a view at the "point" where it becomes visible
 and will "recycle" it as it scrolls past its bounds. Each subsequent pass through will query for the view again.
 
 VLBScrollView will handle bounces of the scrollview gracefully.
 
 To use VLBScrollView in IB, drag a UIScrollView, change its type to VLBScrollView and set its datasource and scrollViewDelegate IBOutlets.
 The **default** VLBScrollView scrolls on the vertical axis and with views of 196px in height.
 
 To programmatically create one, use one of the following factory methods 
 @see #newVerticalScrollView:viewsOf: to create a VLBScrollView scrolling on the vertical axis
 @see #newHorizontalScrollView:viewsOf: to create a VLBScrollView scrolling on the horizontal axis
 @see VLBScrollViewBuilder for optional methods
 */
@interface VLBScrollView : UIScrollView <VisibleStrategyDelegate, VLBCanIndexLocationInView, UIScrollViewDelegate>

/**
 Creates a new scroll view which scrolls on the vertical axis.
 The width of the scrollview is based on the given frame while the height of each view shown in the scrollview is 
 
 @parameter frame the frame of the scrollview
 @parameter height the height of each view in the scrollview as returned by VLBScrollViewDatasource#viewInScrollView:atIndex:
 */
+(VLBScrollView *) newVerticalScrollView:(CGRect)frame viewsOf:(CGFloat)height;

/**
 Creates a new scroll view which scrolls on the horizontal axis.
 
 @param frame the frame of the scroll view
 @param width the width of each view in the axis the scroll view is created
 */
+(VLBScrollView *) newHorizontalScrollView:(CGRect)frame viewsOf:(CGFloat)width;

@property(nonatomic, weak) IBOutlet id <VLBScrollViewDatasource> datasource;
@property(nonatomic, weak) IBOutlet id <VLBScrollViewDelegate> scrollViewDelegate;

// the scrollview will only stop at the edge of a view.
@property(nonatomic, assign, getter = isSeekingEnabled) BOOL enableSeeking;

/**
 Call this method will recycle any subviews that where added as part of 
 VLBScrollView#viewInScrollView:atIndex: effectively removing them from this view.
 
 Any previously visible views are invalidated.
 */
-(void)setNeedsLayout;

@end

/**
  Allows user 
 */
@interface VLBScrollViewBuilder : NSObject

/**
 Creates a new VLBScrollViewBuilder that creates scrollviews with the given frame.
 
 A vertical scrollview will have its views matching in width and a height in the given dimension.
 A horizontal scrollview will have its views matching in height and a width in the given dimension.
 
 @param frame the frame of the scroll view
 @param dimension the dimension of each view in the axis the scroll view is created
 @return a new instance of VLBScrollViewBuilder
 */
- (id)initWith:(CGRect)frame viewsOf:(CGFloat)dimension;

/**
 Enables user selection by tapping in a view.
 
 @discussion @required VLBScrollViewDelegate#didSelectView:atIndex:
 */
-(VLBScrollViewBuilder *)allowSelection;

-(VLBScrollViewBuilder *)canCancelContentTouches;

-(VLBScrollView *)newVerticalScrollView;

-(VLBScrollView *)newHorizontalScrollView;
@end
