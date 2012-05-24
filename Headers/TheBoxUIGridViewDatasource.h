/*
 *  Copyright 2010 The Box
 *  All rights reserved.
 *
 *  This file is part of TheBox
 *
 *  Created by Markos Charatzas (@qnoid) on 28/11/10.
 *  Contributor(s): .-
 */

#import <UIKit/UIKit.h>

@class TheBoxUIGridView;
@class TheBoxUIScrollView;

/**

*/
@protocol TheBoxUIGridViewDatasource<NSObject>

@required
/**
 Return the number of views that the grid view should have in the vertical axis

 @param gridView the grid view this datasource was set to
 */
-(NSUInteger)numberOfViewsInGridView:(TheBoxUIGridView*)gridView;

/**
 Return the number of views that the grid view should have in the horizontal axis for the given index

 @param gridView the grid view this datasource was set to
 @param index the index
 */
-(NSUInteger)numberOfViewsInGridView:(TheBoxUIGridView*)gridView atIndex:(NSInteger)index;

/**

 */
- (UIView *)gridView:(TheBoxUIGridView *)gridView viewOf:(UIView *)view atRow:(NSInteger)row atIndex:(NSInteger)index;

@end
