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
-(NSUInteger)numberOfViews:(TheBoxUIScrollView *)scrollView;
-(UIView*)viewOf:(TheBoxUIScrollView *)scrollView atIndex:(NSInteger)index;

@end
