/*
 *  Copyright 2011 The Box
 *  All rights reserved.
 *
 *  This file is part of TheBox
 *
 *  Created by Markos Charatzas on 24/09/2011.

 */
#import <Foundation/Foundation.h>

@protocol VLBGridViewDelegate <NSObject>

-(void)gridView:(VLBGridView *)gridView viewOf:(UIView *)viewOf atRow:(NSInteger)row atIndex:(NSInteger)index willAppear:(UIView*)view;
-(void)didSelect:(VLBGridView *)gridView atRow:(NSInteger)row atIndex:(NSInteger)index;

@optional
-(void)gridView:(VLBGridView *)gridView atIndex:(NSInteger)index willAppear:(UIView*)view;

-(CGFloat)whatRowHeight:(VLBGridView *)gridView;
-(CGFloat)whatCellWidth:(VLBGridView *)gridView;
-(CGSize)marginOf:(VLBGridView *)scrollView atRow:(NSInteger)row atIndex:(NSInteger)index;
@end
