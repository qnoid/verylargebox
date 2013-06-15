/*
 *  Copyright 2010 The Box
 *  All rights reserved.
 *
 *  This file is part of TheBox
 *
 *  Created by Markos Charatzas on 28/11/10.

 */

#import <UIKit/UIKit.h>

@class VLBGridView;
@class VLBScrollView;

/**

*/
@protocol VLBGridViewDatasource <NSObject>

@required
/**
 Return the number of views that the grid view should have in the vertical axis

 @param gridView the grid view this datasource was set to
 */
-(NSUInteger)numberOfViewsInGridView:(VLBGridView *)gridView;

/**
 Return the number of views that the grid view should have in the horizontal axis for the given index

 @param gridView the grid view this datasource was set to
 @param index the index
 */
-(NSUInteger)numberOfViewsInGridView:(VLBGridView *)gridView atIndex:(NSInteger)index;

- (UIView *)gridView:(VLBGridView *)gridView viewOf:(UIView *)view ofFrame:(CGRect)frame atRow:(NSUInteger)row atIndex:(NSUInteger)index;

@end
