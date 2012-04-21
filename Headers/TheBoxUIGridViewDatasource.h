/*
 *  Copyright 2010 The Box
 *  All rights reserved.
 *
 *  This file is part of TheBox
 *
 *  Created by Markos Charatzas <[firstname.lastname@gmail.com]> on 28/11/10.
 *  Contributor(s): .-
 */

#import <UIKit/UIKit.h>

@protocol TheBoxUIGridViewDatasource<NSObject>

@required
-(NSUInteger)numberOfViews:(TheBoxUIScrollView*)scrollView atIndex:(NSInteger)index;
-(UIView *)viewOf:(TheBoxUIScrollView*)scrollView atRow:(NSInteger)row atIndex:(NSInteger)index;

@end
