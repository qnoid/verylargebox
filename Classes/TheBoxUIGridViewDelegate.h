/*
 *  Copyright 2010 TheBox
 *  All rights reserved.
 *
 *  This file is part of TheBox
 *
 *  Created by Markos Charatzas <[firstname.lastname@gmail.com]> on 21/05/2011.
 *  Contributor(s): .-
 */
#import <Foundation/Foundation.h>
#import "TheBoxUIScrollView.h"
#import "TheBoxUIScrollViewDatasource.h"
#import "TheBoxUIGridViewDatasource.h"

@interface TheBoxUIGridViewDelegate : NSObject <TheBoxUIScrollViewDatasource, TheBoxUIScrollViewDelegate>

@property(nonatomic) id<TheBoxUIGridViewDatasource> datasource;

-(UIView*)viewAtRow:(NSUInteger)row;
-(void)setView:(UIView*)view atIndex:(NSUInteger)index;

@end