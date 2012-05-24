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
#import "TheBoxUIScrollView.h"
#import "TheBoxUIScrollViewDatasource.h"
#import "TheBoxUIGridViewDatasource.h"
#import "CanDequeueReusableView.h"

@protocol TheBoxUIGridViewDelegate;
@class TheBoxUIGridViewController;

@interface TheBoxUIGridView : UIView

@property(nonatomic, unsafe_unretained) IBOutlet id<TheBoxUIGridViewDatasource> datasource;
@property(nonatomic, unsafe_unretained) IBOutlet id<TheBoxUIGridViewDelegate> delegate;

-(void)reload;

@end

@interface FooView : UIView <CanDequeueReusableView>
@property(nonatomic, retain) UIView* header;
@property(nonatomic, retain) TheBoxUIScrollView* contentView;
@end