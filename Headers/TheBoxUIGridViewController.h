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
#import "TheBoxUIGridView.h"
#import "TheBoxUIGridViewDatasource.h"
#import "TheBoxUIGridViewDelegate.h"
@protocol VisibleStrategy;


@interface TheBoxUIGridViewController : UIViewController <TheBoxUIGridViewDatasource, TheBoxUIGridViewDelegate>

@property(nonatomic, assign) CGFloat rowHeight;
@property(nonatomic, assign) CGFloat cellWidth;

/*
 * Default 0
 */
-(NSUInteger)numberOfViewsInGridView:(TheBoxUIGridView *)gridView;

-(NSUInteger)numberOfViewsInGridView:(TheBoxUIGridView*)scrollView atIndex:(NSInteger)index;

@end
