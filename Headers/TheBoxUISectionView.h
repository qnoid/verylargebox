/*
 *  Copyright 2010 The Box
 *  All rights reserved.
 *
 *  This file is part of TheBox
 *
 *  Created by Markos Charatzas <[firstname.lastname@gmail.com]> on 26/11/10.
 *  Contributor(s): .-
 */
#import <Foundation/Foundation.h>
#import "TheBoxUISectionViewDataSource.h"
#import "VisibleStrategy.h"
@class TheBoxSize;
@class TheBoxUISectionView;
@class TheBoxUICell;
@class TheBoxUIRecycleStrategy;
@class TheBoxUIScrollViewDelegate;

@interface TheBoxUISectionView : UIScrollView <VisibleStrategyDelegate>
{
	id <TheBoxUISectionViewDatasource>  datasource;

	@private
		NSInteger index;
		TheBoxSize *theBoxSize;
}

@property(nonatomic, assign) id <TheBoxUISectionViewDatasource>  datasource;
@property(nonatomic, assign) NSInteger index;

-(UIView *)dequeueReusableCell;
@end
