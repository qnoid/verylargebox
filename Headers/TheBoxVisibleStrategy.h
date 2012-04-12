/*
 *  Copyright 2010 The Box
 *  All rights reserved.
 *
 *  This file is part of TheBox
 *
 *  Created by Markos Charatzas <[firstname.lastname@gmail.com]> on 27/11/10.
 *  Contributor(s): .-
 */
#import <Foundation/Foundation.h>
#import "VisibleStrategy.h"
#import "TheBoxSize.h"

#define MINIMUM_VISIBLE_INDEX    NSIntegerMax
#define MAXIMUM_VISIBLE_INDEX    NSIntegerMin
/*
 * Use to normalise the bounds to an index of what's to show while also 
 * keeping track of the minimum and maximum visible view based on it's index
 */
@interface TheBoxVisibleStrategy : NSObject <VisibleStrategy>
{
	@private
		NSInteger minimumVisibleIndex;
		NSInteger maximumVisibleIndex;	
}
@property(nonatomic) id<TheBoxDimension> dimension;

+(TheBoxVisibleStrategy*)newVisibleStrategyOn:(id<TheBoxDimension>) dimension;


- (NSUInteger)minimumVisible:(CGPoint)bounds;

- (NSUInteger)maximumVisible:(CGRect)bounds;

/*
 * 
 * For every visible index calculated given the bounds a call to VisibleStrategyDelegate#shouldBeVisible
 * will be made
 *
 * @param bounds the visible bounds which 
 */
- (void)willAppear:(CGRect) bounds;

@end
