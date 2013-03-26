/*
 *  Copyright 2010 TheBox
 *  All rights reserved.
 *
 *  This file is part of TheBox
 *
 *  Created by Markos Charatzas (@qnoid) on 21/05/2011.
 *  Contributor(s): .-
 */
#import <Foundation/Foundation.h>

@protocol TheBoxUIGridViewDatasource;
@protocol TheBoxUIGridViewDelegate;

@interface TheBoxUIGridView : UIView

@property(nonatomic, unsafe_unretained) IBOutlet id<TheBoxUIGridViewDatasource> datasource;
@property(nonatomic, unsafe_unretained) IBOutlet id<TheBoxUIGridViewDelegate> delegate;

//@default NO
@property(nonatomic, assign) BOOL showsVerticalScrollIndicator;

+(instancetype)newVerticalGridView:(CGRect)frame viewsOf:(CGFloat)height;

-(void)reload;
- (void)flashScrollIndicators;

@end