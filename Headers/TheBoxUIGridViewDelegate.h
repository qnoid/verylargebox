/*
 *  Copyright 2011 The Box
 *  All rights reserved.
 *
 *  This file is part of TheBox
 *
 *  Created by Markos Charatzas (@qnoid) on 24/09/2011.
 *  Contributor(s): .-
 */
#import <Foundation/Foundation.h>

@protocol TheBoxUIGridViewDelegate <NSObject>

-(void)gridView:(TheBoxUIGridView*)gridView viewOf:(UIView *)viewOf atRow:(NSInteger)row atIndex:(NSInteger)index willAppear:(UIView*)view;
-(void)didSelect:(TheBoxUIGridView *)gridView atRow:(NSInteger)row atIndex:(NSInteger)index;

@optional
-(void)gridView:(TheBoxUIGridView*)gridView atIndex:(NSInteger)index willAppear:(UIView*)view;

-(CGFloat)whatRowHeight:(TheBoxUIGridView*)gridView;
-(CGFloat)whatCellWidth:(TheBoxUIGridView*)gridView;
-(CGSize)marginOf:(TheBoxUIGridView*)scrollView atRow:(NSInteger)row atIndex:(NSInteger)index;
@end
