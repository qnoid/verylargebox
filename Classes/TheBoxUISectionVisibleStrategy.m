/*
 *  Copyright 2010 The Box
 *  All rights reserved.
 *
 *  This file is part of TheBox
 *
 *  Created by Markos Charatzas <[firstname.lastname@gmail.com]> on 27/11/10.
 *  Contributor(s): .-
 */
#import "TheBoxUISectionVisibleStrategy.h"

@interface TheBoxUISectionVisibleStrategy ()
-(BOOL) isVisible:(NSInteger) index;
@end


@implementation TheBoxUISectionVisibleStrategy

@synthesize delegate;
@synthesize visibleViews;
@synthesize currentMinimumVisibleSection;
@synthesize currentMaximumVisibleSection;

- (void) dealloc
{
	[self.visibleViews release];
	[super dealloc];
}

- (id)init
{
	self = [super init];
	
	if (self) 
	{
		self.visibleViews = [[NSMutableSet alloc] init]; 
		self.currentMinimumVisibleSection = NSIntegerMax;
        self.currentMaximumVisibleSection = NSIntegerMin;
	}
	
	return self;
}

-(BOOL) isVisible:(NSInteger) index 
{
	BOOL isVisible = (self.currentMinimumVisibleSection <= index) && (index <= self.currentMaximumVisibleSection);
	
	NSLog(@"is section: %d visible {%d <= %d <= %d}? %@", index, currentMinimumVisibleSection, index, currentMaximumVisibleSection, (isVisible ? @"YES" : @"NO"));

return isVisible;
}

- (void)willAppear:(CGSize)size within:(CGRect) bounds
{
	NSInteger visibleWindowStart = bounds.origin.y;
	NSInteger visibleWindowHeight = CGRectGetHeight(bounds);
	
	NSInteger minimumVisibleSection = floor(visibleWindowStart / size.height);
	NSInteger maximumVisibleSection = ceilf((visibleWindowStart + visibleWindowHeight) / size.height);
		
	NSLog(@"%d >= visible sections < %d", minimumVisibleSection, maximumVisibleSection);
	
	for (int currentSection = minimumVisibleSection; currentSection < maximumVisibleSection; currentSection++) 
	{
		if(![self isVisible:currentSection])
		{
			NSLog(@"section %d isn't currently visible {%d <= %d <= %d}", currentSection, currentMinimumVisibleSection, currentSection, currentMaximumVisibleSection);			
			UIView *view = [self.delegate shouldBeVisible:currentSection];
			[self.visibleViews addObject:view];
		}
	}
	
	self.currentMinimumVisibleSection = minimumVisibleSection;
	self.currentMaximumVisibleSection = maximumVisibleSection - 1;	
}

-(void) reset
{
	self.currentMinimumVisibleSection = NSIntegerMax;
	self.currentMaximumVisibleSection = NSIntegerMin;
}

@end
