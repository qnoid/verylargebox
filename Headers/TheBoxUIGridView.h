/*
 *  Copyright 2010 The Box
 *  All rights reserved.
 *
 *  This file is part of TheBox
 *
 *  Created by Markos Charatzas <[firstname.lastname@gmail.com]> on 8/11/10.
 *  Contributor(s): .-
 */
#import <UIKit/UIKit.h>
#import "TheBoxUIGridViewDataSource.h"
#import "TheBoxUISectionViewDataSource.h"
#import "VisibleStrategy.h"
@class TheBoxSize;
@class TheBoxUIScrollViewDelegate;
@class TheBoxUISectionView;
@class TheBoxUIRecycleStrategy;
@class TheBoxUIScrollViewDelegate;
@class TheBoxUISectionViewConfiguration;


@protocol TheBoxUIGridViewDelegate

@optional
- (CGFloat)whatRowHeight:(TheBoxUIGridView *)gridView;
@end

@interface TheBoxUIGridView : UIScrollView <VisibleStrategyDelegate>
{
	@private
		id <TheBoxUIGridViewDatasource>  datasource;
		id <TheBoxUIGridViewDelegate>  gridViewDelegate;
		TheBoxSize *theBoxSize;
}

+(TheBoxUIGridView *) newGridView:(CGRect) frame datasource:(id<TheBoxUIGridViewDatasource>)datasource delegate:(id<TheBoxUIGridViewDelegate>)gridViewDelegate;

@property(nonatomic, assign) id <TheBoxUIGridViewDatasource> datasource;
@property(nonatomic, assign) id <TheBoxUIGridViewDelegate> gridViewDelegate;

-(UIView*) dequeueReusableSection;

@end