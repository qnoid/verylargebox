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

@interface TheBoxUISectionVisibleStrategy : NSObject <VisibleStrategy>
{
	id <VisibleStrategyDelegate> delegate;
	@private
		NSMutableSet *visibleViews;
		NSInteger currentMinimumVisibleSection;
		NSInteger currentMaximumVisibleSection;	
}

@property(nonatomic, assign) NSInteger currentMinimumVisibleSection;
@property(nonatomic, assign) NSInteger currentMaximumVisibleSection;

- (id)init;

/*
 * Visible bounds
 * Callbacl to delegate isVisible for as many indexes 
 */
- (void)willAppear:(CGSize)size within:(CGRect) bounds;

-(void)reset;

@end
