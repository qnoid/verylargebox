/*
 *  Copyright 2010 The Box
 *  All rights reserved.
 *
 *  This file is part of TheBox
 *
 *  Created by Markos Charatzas (@qnoid) on 19/05/2012.
 *  Contributor(s): .-
 */
#import <UIKit/UIKit.h>
#import "TheBoxUIScrollView.h"

/**
  Implementations of this protocol provide a custom drawRect method.
 
 @param rect the rect as passed in UIView#drawRect:
 @param view the view that was created with this
 
 @see UIView#drawRect:
 */
@protocol TBUIViewDrawRect <NSObject>
- (void)drawRect:(CGRect)rect onView:(UIView*)view;
@end

/**
 A UIView that allows you to implement drawRect via composition.
 
 */
@interface TBUIView : UIView
@property(nonatomic, strong) NSObject<TBUIViewDrawRect> *drawRect;
@end
