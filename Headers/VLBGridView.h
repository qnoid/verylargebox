/*
 *  Copyright (c) 2010 (verylargebox.com). All rights reserved.
 *  All rights reserved.
 *
 *  This file is part of TheBox
 *
 *  Created by Markos Charatzas on 21/05/2011.

 */
#import <Foundation/Foundation.h>

@protocol VLBGridViewDatasource;
@protocol VLBGridViewDelegate;

@interface VLBGridView : UIView

@property(nonatomic, unsafe_unretained) IBOutlet id<VLBGridViewDatasource> datasource;
@property(nonatomic, unsafe_unretained) IBOutlet id<VLBGridViewDelegate> delegate;

//@default NO
@property(nonatomic, assign) BOOL showsVerticalScrollIndicator;

+(instancetype)newVerticalGridView:(CGRect)frame viewsOf:(CGFloat)height;

-(void)reload;
- (void)flashScrollIndicators;

@end