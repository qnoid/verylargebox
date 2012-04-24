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

@interface TheBoxVisibleStrategy ()

/*
 * @param dimension the dimension to use when calculating the index in respect to the visible bounds
 */
-(id)init:(id<TheBoxDimension>) dimension;
@property(nonatomic, copy) MaximumVisibleIndexPrecondition maximumVisibleIndexPrecondition;
@end


@implementation TheBoxVisibleStrategy
{
    NSMutableSet *visibleViews;
}

+(TheBoxVisibleStrategy*)newVisibleStrategyOnWidth:(CGFloat) width
{
	TheBoxVisibleStrategy *visibleStrategy = 
    [TheBoxVisibleStrategy newVisibleStrategyOn:
     [TheBoxWidth newWidth:width]];
	
return visibleStrategy;	
}

+(TheBoxVisibleStrategy*)newVisibleStrategyOnHeight:(CGFloat) height
{
	TheBoxVisibleStrategy *visibleStrategy = 
    [TheBoxVisibleStrategy newVisibleStrategyOn:
     [TheBoxHeight newHeight:height]];
	
    return visibleStrategy;	
}

+(TheBoxVisibleStrategy*)newVisibleStrategyOn:(id<TheBoxDimension>) dimension
{
	TheBoxVisibleStrategy *visibleStrategy = [[TheBoxVisibleStrategy alloc] init:dimension];
	
return visibleStrategy;	
}

+(TheBoxVisibleStrategy*)newVisibleStrategyFrom:(TheBoxVisibleStrategy*) visibleStrategy
{
	TheBoxVisibleStrategy *newVisibleStrategy = [[TheBoxVisibleStrategy alloc] init:visibleStrategy.dimension];
	
return newVisibleStrategy;	
}

@synthesize dimension;
@synthesize delegate;
@synthesize visibleViews;
@synthesize minimumVisibleIndex;
@synthesize maximumVisibleIndex;
@synthesize maximumVisibleIndexPrecondition;

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
        self.maximumVisibleIndexPrecondition = acceptMaximumVisibleIndex();
	}
	
return self;
}

-(void)maximumVisibleIndexShould:(MaximumVisibleIndexPrecondition)conformToPrecondition{
    self.maximumVisibleIndexPrecondition = conformToPrecondition;
}

-(BOOL) isVisible:(NSInteger) index 
{
	BOOL isVisible = (minimumVisibleIndex <= index) && (index <= maximumVisibleIndex);
	
	NSLog(@"%d visible? {%d <= %d <= %d} %@", index, minimumVisibleIndex, index, maximumVisibleIndex, (isVisible ? @"YES" : @"NO"));

return isVisible;
}

-(BOOL)isVisibleBetweenMinimum:(NSInteger)minimumVisible andMaximum:(NSInteger)maximumVisible{
return [self isVisible:minimumVisible] && [self isVisible:maximumVisible];
}

- (NSUInteger)minimumVisible:(CGPoint)bounds {
    return [self.dimension minimumVisible:bounds];
}

- (NSUInteger)maximumVisible:(CGRect)bounds {
    return [self.dimension maximumVisible:bounds];
}

- (BOOL)needsLayoutSubviews:(CGRect) bounds
{
    NSInteger minimumVisible = [self minimumVisible:bounds.origin];
	NSInteger maximumVisible = [self maximumVisible:bounds];
	
	maximumVisible = self.maximumVisibleIndexPrecondition(self.maximumVisibleIndex, maximumVisible);
    
return !([self isVisibleBetweenMinimum:minimumVisible andMaximum:maximumVisible - 1]);
}

- (void)layoutSubviews:(CGRect) bounds
{
    NSInteger minimumVisible = [self minimumVisible:bounds.origin];
	NSInteger maximumVisible = [self maximumVisible:bounds];
	
	maximumVisible = self.maximumVisibleIndexPrecondition(self.maximumVisibleIndex, maximumVisible);
    
	NSLog(@"%d >= willAppear < %d of dimension %@ on bounds %@", minimumVisible, maximumVisible, self.dimension, NSStringFromCGRect(bounds));
	
	for (int index = minimumVisible; index < maximumVisible; index++) 
	{
		if(![self isVisible:index])
		{
			NSLog(@"%d should be visible", index);
			UIView *view = [self.delegate shouldBeVisible:index];
			[self.visibleViews addObject:view];
		}
	}
	
    self.minimumVisibleIndex = minimumVisible;
	self.maximumVisibleIndex = maximumVisible - 1;
	
	NSLog(@"minimum visible: %d, maximum visible: %d", self.minimumVisibleIndex, self.maximumVisibleIndex);
}

- (CGRect)visibleBounds:(CGRect)bounds withinContentSize:(CGSize)contentSize
{
    CGPoint origin = [self.dimension ceilOriginOf:bounds toContentSize:contentSize];
return CGRectMake(origin.x, origin.y, bounds.size.width, bounds.size.height);
}

@end
