/*
 *  Copyright 2010 The Box
 *  All rights reserved.
 *
 *  This file is part of TheBox
 *
 *  Created by Markos Charatzas <[firstname.lastname@gmail.com]> on 27/11/10.
 *  Contributor(s): .-
 */
#import "TheBoxVisibleStrategy.h"
#import "TheBoxSize.h"

@interface TheBoxVisibleStrategy ()

/*
 * @param dimension the dimension to use when calculating the index in respect to the visible bounds
 */
-(id)init:(id<TheBoxDimension>) dimension;
@end


@implementation TheBoxVisibleStrategy


+(TheBoxVisibleStrategy*)newVisibleStrategyOnHeight:(CGSize) size
{
	TheBoxSize *theBoxSize = [[TheBoxSize alloc] initWithSize:size];
	TheBoxVisibleStrategy *visibleStrategy = [[TheBoxVisibleStrategy alloc] init:[theBoxSize height]];
	[theBoxSize release];
	
return visibleStrategy;	
}

+(TheBoxVisibleStrategy*)newVisibleStrategyOnWidth:(CGSize) size
{
	TheBoxSize *theBoxSize = [[TheBoxSize alloc] initWithSize:size];
	TheBoxVisibleStrategy *visibleStrategy = [[TheBoxVisibleStrategy alloc] init:[theBoxSize width]];
	[theBoxSize release];
	
return visibleStrategy;
}
	

NSMutableSet *visibleViews;

@synthesize dimension;
@synthesize delegate;
@synthesize visibleViews;
@synthesize minimumVisibleIndex;
@synthesize maximumVisibleIndex;

- (void) dealloc
{
	[self.dimension release];
	[self.visibleViews release];
	[super dealloc];
}

- (id)init:(id<TheBoxDimension>) onDimension
{
	self = [super init];
	
	if (self) 
	{
		self.dimension = onDimension;
		self.visibleViews = [[NSMutableSet alloc] init]; 
		minimumVisibleIndex = MINIMUM_VISIBLE_INDEX;
        maximumVisibleIndex = MAXIMUM_VISIBLE_INDEX;
	}
	
return self;
}

-(BOOL) isVisible:(NSInteger) index 
{
	BOOL isVisible = (minimumVisibleIndex <= index) && (index <= maximumVisibleIndex);
	
	NSLog(@"%d visible? {%d <= %d <= %d} %@", index, minimumVisibleIndex, index, maximumVisibleIndex, (isVisible ? @"YES" : @"NO"));

return isVisible;
}

- (void)willAppear:(CGRect) bounds
{
	NSInteger theMinimumVisibleIndex = [self.dimension minimumVisible:bounds];	
	NSInteger theMaximumVisibleIndex = [self.dimension maximumVisible:bounds];
		
	NSLog(@"%d >= willAppear < %d of dimension %@ on bounds %@", theMinimumVisibleIndex, theMaximumVisibleIndex, self.dimension, NSStringFromCGRect(bounds));
	
	for (int index = theMinimumVisibleIndex; index < theMaximumVisibleIndex; index++) 
	{
		if(![self isVisible:index])
		{
			NSLog(@"%d should be visible", index);
			UIView *view = [self.delegate shouldBeVisible:index];
			[self.visibleViews addObject:view];
		}
	}
	
	minimumVisibleIndex = theMinimumVisibleIndex;
	maximumVisibleIndex = theMaximumVisibleIndex - 1;	
}

@end
