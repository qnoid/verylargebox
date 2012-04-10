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
{
    NSMutableSet *visibleViews;
}

+(TheBoxVisibleStrategy*)newVisibleStrategyOn:(id<TheBoxDimension>) dimension
{
	TheBoxVisibleStrategy *visibleStrategy = [[TheBoxVisibleStrategy alloc] init:dimension];
	
return visibleStrategy;	
}


@synthesize dimension;
@synthesize delegate;
@synthesize visibleViews;
@synthesize minimumVisibleIndex;
@synthesize maximumVisibleIndex;


- (id)init:(id<TheBoxDimension>) onDimension
{
	self = [super init];
	
	if (self) 
	{
        NSMutableSet* theVisibleViews = [[NSMutableSet alloc] init];
        
		self.dimension = onDimension;        
		self.visibleViews = theVisibleViews;
        
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
	
	self.minimumVisibleIndex = theMinimumVisibleIndex;
	self.maximumVisibleIndex = theMaximumVisibleIndex - 1;
	
	NSLog(@"minimum visible: %d, maximum visible: %d", self.minimumVisibleIndex, self.maximumVisibleIndex);
}

@end
