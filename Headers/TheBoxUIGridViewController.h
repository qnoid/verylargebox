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
#import "TheBoxUIScrollView.h"
#import "TheBoxUIScrollViewDatasource.h"
#import "TheBoxUIGridViewDelegate.h"
#import "TheBoxUIGridViewDatasource.h"
@class TheBoxUIGridView;
@protocol VisibleStrategy;


@interface TheBoxUIGridViewController : UIViewController <TheBoxUIScrollViewDelegate, TheBoxUIGridViewDatasource, TheBoxUIGridViewDelegate, TheBoxUIScrollViewDatasource>

@property(nonatomic) TheBoxUIScrollView* gridView;

-(void)reloadData;

/*
 * Default 0
 */
-(NSUInteger)numberOfViews:(TheBoxUIScrollView *)scrollView;
-(UIView*)viewOf:(TheBoxUIScrollView *)scrollView atIndex:(NSInteger)index;

-(NSUInteger)numberOfViews:(TheBoxUIScrollView*)scrollView atIndex:(NSInteger)index;
-(UIView*)viewOf:(TheBoxUIScrollView*)scrollView atRow:(NSInteger)row atIndex:(NSInteger)index;

-(CGSize)marginOf:(TheBoxUIScrollView*)scrollView atRow:(NSInteger)row atIndex:(NSInteger)index;
/*
 *
 */
-(CGRect)frameOf:(TheBoxUIScrollView *)scrollView atRow:(NSInteger)row atIndex:(NSInteger)index;

@end
