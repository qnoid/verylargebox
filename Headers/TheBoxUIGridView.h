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
#import <Foundation/Foundation.h>
#import "TheBoxUIGridViewDataSource.h"
#import "TheBoxUISectionViewDataSource.h"
#import "VisibleStrategy.h"
@class TheBoxUISectionViewBuilder;
@class TheBoxUISectionView;
@class TheBoxUIRecycleStrategy;
@class TheBoxUIRecycleView;

@interface TheBoxUIGridView : UIScrollView <UIScrollViewDelegate, VisibleStrategyDelegate>
{
	id <TheBoxUIGridViewDatasource>  datasource;
	
	@private
		TheBoxUIRecycleView *subview;
		TheBoxUISectionViewBuilder *sectionBuilder;
		NSUInteger numberOfSectionsPerGridView;
		CGSize sectionSize;
}

+(TheBoxUIGridView *) newGridView:(CGRect)frame datasource:(id<TheBoxUIGridViewDatasource>) datasource;


@property(nonatomic, assign) id <TheBoxUIGridViewDatasource>  datasource;

@property (nonatomic, retain) TheBoxUIRecycleView *subview;
/*
 * how many section to display per grid view
 */
@property(nonatomic, assign) TheBoxUISectionViewBuilder *sectionBuilder;
@property(nonatomic, assign) NSUInteger numberOfSectionsPerGridView;
@property(nonatomic, assign) CGSize sectionSize;

/*
 * Override to customize section
 */
-(UIView *)viewForSection:(NSInteger)section;

/*
 * @return the number of sections in the grid
 */
-(NSUInteger)numberOfSections;

@end
