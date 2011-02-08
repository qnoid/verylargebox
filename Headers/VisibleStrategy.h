/*
 *  Copyright 2010 The Box
 *  All rights reserved.
 *
 *  This file is part of TheBox
 *
 *  Created by Markos Charatzas <[firstname.lastname@gmail.com]> on 27/11/10.
 *  Contributor(s): .-
 */

#import <UIKit/UIKit.h>

@protocol VisibleStrategyDelegate<NSObject>

/*
 * @return the view corresponding to the index
 */
-(UIView *)shouldBeVisible:(int)index;

@end


@protocol VisibleStrategy<NSObject>

/*
 * Visible bounds
 * Callback to delegate isVisible for as many indexes 
 */
- (void)willAppear:(CGSize)size within:(CGRect) bounds;

- (void)reset;

@property(nonatomic, assign) id<VisibleStrategyDelegate> delegate;

@required
@property(nonatomic, retain) NSMutableSet *visibleViews;

@end
