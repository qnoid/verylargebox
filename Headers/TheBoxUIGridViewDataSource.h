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
@class TheBoxUIGridView;
@class TheBoxUISectionView;

@protocol TheBoxUIGridViewDatasource <NSObject>

@required
-(NSInteger)numberOfSectionsInGridView:(TheBoxUIGridView *)gridView;
-(UIView *)gridView:(TheBoxUIGridView *)gridView sectionForIndex:(NSInteger)index;

@end
