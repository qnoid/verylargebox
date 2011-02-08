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

@interface TheBoxUICellVisibleStrategy : NSObject <VisibleStrategy>
{
	id <VisibleStrategyDelegate> delegate;
	@private
		NSMutableSet *visibleViews;	
		NSInteger currentMinimumVisibleCell;
		NSInteger currentMaximumVisibleCell;	
}

@property(nonatomic, assign) NSInteger currentMinimumVisibleCell;
@property(nonatomic, assign) NSInteger currentMaximumVisibleCell;


-(id)init;

-(BOOL) isVisible:(NSInteger) index;

/*
 * Visible bounds
 * Callbacl to delegate isVisible for as many times
 */
-(void)willAppear:(CGSize)size within:(CGRect) bounds;
-(void) reset;

@end
