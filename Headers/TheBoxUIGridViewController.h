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

#import "TheBoxUIGridViewDataSource.h"
#import "TheBoxUISectionViewDataSource.h"


@interface TheBoxUIGridViewController : UIViewController <TheBoxUIGridViewDatasource, TheBoxUIGridViewDelegate, TheBoxUISectionViewDatasource>
{
}

-(void)setNeedsLayout;

/*
 * Override to customize section
 */
-(UIView *)gridView:(TheBoxUIGridView *)gridView section:(UIView *)section forSection:(NSInteger)section;

/*
 * Override to customize a column
 */
-(UIView *)gridView:(TheBoxUIGridView *)gridView forColumn:(UIView *)column withIndex:(NSInteger)index;

/*
 * Default 0
 */
-(NSInteger)numberOfSectionsInGridView:(TheBoxUIGridView *)theGridView;

-(NSUInteger)numberOfColumnsInSection:(NSUInteger)index;

@end
