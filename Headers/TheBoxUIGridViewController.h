/*
 *  Copyright 2010 The Box
 *  All rights reserved.
 *
 *  This file is part of TheBox
 *
 *  Created by Markos Charatzas <[firstname.lastname@gmail.com]> on 23/11/10.
 *  Contributor(s): .-
 */
#import <Foundation/Foundation.h>
#import "TheBoxUIGridViewDataSource.h"
#import "TheBoxUISectionViewDataSource.h"
@class TheBoxUIGridView;

@interface TheBoxUIGridViewController : UIViewController <TheBoxUIGridViewDatasource, TheBoxUISectionViewDatasource>
{
}

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
