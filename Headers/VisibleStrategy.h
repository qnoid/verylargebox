/*
 *  Copyright 2010 The Box
 *  All rights reserved.
 *
 *  This file is part of TheBox
 *
 *  Created by Markos Charatzas <[firstname.lastname@gmail.com]> on 27/11/10.
 *  Contributor(s): .-
 */
#import <UIKit/UIKit.h>

@protocol VisibleStrategyDelegate<NSObject>

/*
 * @return the view corresponding to the index
 */
-(UIView *)shouldBeVisible:(int)index;

@end


@protocol VisibleStrategy<NSObject>

-(BOOL)isVisible:(NSInteger) index;
/*
 * Visible bounds
 * Callback to delegate isVisible for as many indexes 
 */
-(void)willAppear:(CGRect)bounds;


@property(nonatomic, assign) id<VisibleStrategyDelegate> delegate;

@required
@property(nonatomic, retain) NSMutableSet *visibleViews;
@property(nonatomic, assign) NSInteger minimumVisibleIndex;
@property(nonatomic, assign) NSInteger maximumVisibleIndex;

@end
