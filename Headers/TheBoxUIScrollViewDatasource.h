/*
 *  Copyright 2010 The Box
 *  All rights reserved.
 *
 *  This file is part of TheBox
 *
 *  Created by Markos Charatzas <[firstname.lastname@gmail.com]> on 23/11/10.
 *  Contributor(s): .-
 */

#import <UIKit/UIKit.h>
@class TheBoxUIScrollView;
@class TheBoxUISectionView;

@protocol TheBoxUIScrollViewDatasource <NSObject>

@required

/**
 Return the number of views in the scroll view.

 @param scrollView the scroll view this datasource was set to
 */
-(NSUInteger)numberOfViewsInScrollView:(TheBoxUIScrollView *)scrollView;


/**
 Called every time a view is within the bounds of the scrollview.

 Indexes are in sequential order starting from 0 up to the number of views as returned by #numberOfViewsInScrollView: minus 1.

 @param scrollView the scroll view this datasource was set to
 @param index the index which identifies the view
 */
-(UIView*)viewInScrollView:(TheBoxUIScrollView *)scrollView atIndex:(NSInteger)index;

@end
