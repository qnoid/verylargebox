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
@class TheBoxUIGridView;
@class TheBoxUISectionView;

@protocol TheBoxUISectionViewDatasource<NSObject>

@required
-(NSUInteger)numberOfColumnsInSection:(NSUInteger)index;
-(UIView *)sectionView:(TheBoxUISectionView *)sectionView cellForIndex:(NSInteger)index;

@end
