/*
 *  Copyright 2011 The Box
 *  All rights reserved.
 *
 *  This file is part of TheBox
 *
 *  Created by Markos Charatzas <[firstname.lastname@gmail.com]> on 24/09/2011.
 *  Contributor(s): .-
 */
#import <Foundation/Foundation.h>

@protocol TheBoxUIGridViewDelegate <NSObject>

-(CGSize)marginOf:(TheBoxUIGridView*)scrollView atRow:(NSInteger)row atIndex:(NSInteger)index;
-(void)didSelect:(TheBoxUIGridView *)gridView atRow:(NSInteger)row atIndex:(NSInteger)index;

@optional
-(CGFloat)whatRowHeight:(TheBoxUIGridView*)gridView;
-(CGFloat)whatCellWidth:(TheBoxUIGridView*)gridView;

@end
