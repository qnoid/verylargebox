/*
 *  Copyright 2010 The Box
 *  All rights reserved.
 *
 *  This file is part of TheBox
 *
 *  Created by Markos Charatzas on 23/11/10.

 */
#import <UIKit/UIKit.h>
#import "VLBGridView.h"
#import "VLBGridViewDatasource.h"
#import "VLBGridViewDelegate.h"
@protocol VLBVisibleStrategy;


@interface VLBGridViewController : UIViewController <VLBGridViewDatasource, VLBGridViewDelegate>

@property(nonatomic, assign) CGFloat rowHeight;
@property(nonatomic, assign) CGFloat cellWidth;

/*
 * Default 0
 */
-(NSUInteger)numberOfViewsInGridView:(VLBGridView *)gridView;

-(NSUInteger)numberOfViewsInGridView:(VLBGridView *)scrollView atIndex:(NSInteger)index;

@end
