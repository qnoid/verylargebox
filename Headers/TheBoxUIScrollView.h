/*
 *  Copyright 2011 TheBox
 *  All rights reserved.
 *
 *  This file is part of TheBox
 *
 *  Created by Markos Charatzas <[firstname.lastname@gmail.com]> on 07/02/2011.
 *  Contributor(s): .-
 */
#import <UIKit/UIKit.h>
#import "VisibleStrategy.h"
#import "TheBoxUIScrollViewDatasource.h"
@class TheBoxUIRecycleStrategy;
@class VisibleStrategy;
@class TheBoxUIScrollView;
@class TheBoxSize;
@protocol TheBoxUIScrollViewDatasource;
@protocol TheBoxDimension;

@protocol TheBoxUIScrollViewDelegate 

-(CGSize)contentSizeOf:(TheBoxUIScrollView *)scrollView withData:(id<TheBoxUIScrollViewDatasource>)datasource;

@optional
- (CGFloat)whatSize:(TheBoxUIScrollView *)scrollView;
@end

/*
 * An implementation of UIScrollView which recycles views and calculates visible ones.
 * Is it's own delegate
 */
@interface TheBoxUIScrollView : UIScrollView <UIScrollViewDelegate, VisibleStrategyDelegate>

+(TheBoxUIScrollView *) newVerticalScrollView:(CGRect)frame viewsOf:(CGFloat)height;
+(TheBoxUIScrollView *) newHorizontalScrollView:(CGRect)frame viewsOf:(CGFloat)width;
+(TheBoxUIScrollView *) newScrollView:(CGRect)frame recycleStrategy:(TheBoxUIRecycleStrategy *)recycleStrategy visibleStrategy:(id<VisibleStrategy>) visibleStrategy;

@property(nonatomic, unsafe_unretained) id <TheBoxUIScrollViewDatasource> datasource;
@property(nonatomic, unsafe_unretained) id <TheBoxUIScrollViewDelegate> scrollViewDelegate;
@property(nonatomic, strong) TheBoxSize *theBoxSize;

-(NSUInteger)indexOf:(CGPoint)point;
-(UIView*)dequeueReusableView;

@end
