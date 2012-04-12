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

@class TheBoxUIScrollView;
@protocol TheBoxUIGridViewDelegate <NSObject>

-(CGSize)marginOf:(TheBoxUIScrollView*)scrollView atRow:(NSInteger)row atIndex:(NSInteger)index;
-(void)didSelect:(TheBoxUIScrollView *)scrollView atRow:(NSInteger)row atIndex:(NSInteger)index;
@end
