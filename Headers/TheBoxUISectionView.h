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
#import "TheBoxUICellVisibleStrategy.h"
#import "TheBoxUISectionViewDataSource.h"
@class TheBoxUICell;
@class TheBoxUIRecycleStrategy;
@class TheBoxUIRecycleView;

@interface TheBoxUISectionView : UIScrollView <UIScrollViewDelegate, VisibleStrategyDelegate>
{
	id <TheBoxUISectionViewDatasource>  datasource;

	@private
		TheBoxUIRecycleView *subview;
		NSInteger index;
		NSInteger currentCellIndex;
		CGSize cellSize;
		NSInteger numberOfColumnsPerSectionView;
}
@property(nonatomic, assign) id <TheBoxUISectionViewDatasource>  datasource;
@property (nonatomic, retain) TheBoxUIRecycleView *subview;
@property(nonatomic, assign) NSInteger index;
@property(nonatomic, assign) NSInteger currentCellIndex;
@property(nonatomic, assign) CGSize cellSize;
@property(nonatomic, assign) NSInteger numberOfColumnsPerSectionView;

-(NSInteger)numberOfColumns;
-(UIView *)viewForColumn:(NSUInteger)index inSection:(NSUInteger) section;

@end
