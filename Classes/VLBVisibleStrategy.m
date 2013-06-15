//
//  Copyright 2010 The Box
//  All rights reserved.
//
//  This file is part of TheBox
//
//  Created by Markos Charatzas on 27/11/10.
//

#import "VLBVisibleStrategy.h"

@interface VLBVisibleStrategy ()

/*
 * @param dimension the dimension to use when calculating the index in respect to the visible bounds
 */
-(id)init:(id<VLBDimension>) dimension;
@property(nonatomic, copy) VisibleIndexPrecondition maximumVisibleIndexPrecondition;
@property(nonatomic, copy) VisibleIndexPrecondition minimumVisibleIndexPrecondition;
@end


@implementation VLBVisibleStrategy
{
    NSMutableSet *visibleViews;
}

+(VLBVisibleStrategy *)newVisibleStrategyOnWidth:(CGFloat) width
{
	VLBVisibleStrategy *visibleStrategy =
    [VLBVisibleStrategy newVisibleStrategyOn:
            [VLBWidth newWidth:width]];
	
return visibleStrategy;	
}

+(VLBVisibleStrategy *)newVisibleStrategyOnHeight:(CGFloat) height
{
	VLBVisibleStrategy *visibleStrategy =
    [VLBVisibleStrategy newVisibleStrategyOn:
            [VLBHeight newHeight:height]];
	
    return visibleStrategy;	
}

+(VLBVisibleStrategy *)newVisibleStrategyOn:(id<VLBDimension>) dimension
{
	VLBVisibleStrategy *visibleStrategy = [[VLBVisibleStrategy alloc] init:dimension];
	
return visibleStrategy;	
}

+(VLBVisibleStrategy *)newVisibleStrategyFrom:(VLBVisibleStrategy *) visibleStrategy
{
	VLBVisibleStrategy *newVisibleStrategy = [[VLBVisibleStrategy alloc] init:visibleStrategy.dimension];
	
return newVisibleStrategy;	
}

@synthesize dimension;
@synthesize delegate;
@synthesize visibleViews;
@synthesize minimumVisibleIndex;
@synthesize maximumVisibleIndex;
@synthesize maximumVisibleIndexPrecondition;
@synthesize minimumVisibleIndexPrecondition;

- (id)init:(id<VLBDimension>) onDimension
{
	self = [super init];
	
	if (self) 
	{
        NSMutableSet* theVisibleViews = [[NSMutableSet alloc] init];
        
		self.dimension = onDimension;        
		self.visibleViews = theVisibleViews;
        
		minimumVisibleIndex = VLB_MINIMUM_VISIBLE_INDEX;
        maximumVisibleIndex = VLB_MAXIMUM_VISIBLE_INDEX;
        self.maximumVisibleIndexPrecondition = acceptAnyVisibleIndex();
        self.minimumVisibleIndexPrecondition = acceptAnyVisibleIndex();
	}
	
return self;
}

-(void)minimumVisibleIndexShould:(VisibleIndexPrecondition)conformToPrecondition{
    self.minimumVisibleIndexPrecondition = conformToPrecondition;
}

-(void)maximumVisibleIndexShould:(VisibleIndexPrecondition)conformToPrecondition{
    self.maximumVisibleIndexPrecondition = conformToPrecondition;
}

-(BOOL) isVisible:(NSInteger) index 
{
	BOOL isVisible = (minimumVisibleIndex <= index) && (index <= maximumVisibleIndex);
	
	DDLogVerbose(@"%d visible? {%d <= %d <= %d} %@", index, minimumVisibleIndex, index, maximumVisibleIndex, (isVisible ? @"YES" : @"NO"));

return isVisible;
}

- (NSInteger)minimumVisible:(CGPoint)bounds {
    return [self.dimension floorIndexOf:bounds];
}

- (NSInteger)maximumVisible:(CGRect)bounds {
    return [self.dimension ceilIndexOf:bounds];
}

- (void)layoutSubviews:(CGRect) bounds
{
    NSInteger minimumVisible = [self minimumVisible:bounds.origin];
	NSInteger maximumVisible = [self maximumVisible:bounds];
	
    minimumVisible = self.minimumVisibleIndexPrecondition(self.minimumVisibleIndex, minimumVisible);
	maximumVisible = self.maximumVisibleIndexPrecondition(self.maximumVisibleIndex, maximumVisible);

	DDLogVerbose(@"%d >= willAppear < %d of dimension %@ on bounds %@", minimumVisible, maximumVisible, self.dimension, NSStringFromCGRect(bounds));
    
	for (int index = minimumVisible; index < maximumVisible; index++) 
	{
		if(![self isVisible:index]) //should be called anyway
		{
            [self.delegate viewsShouldBeVisibleBetween:minimumVisible to:maximumVisible];
            
			DDLogVerbose(@"%d should be visible", index);
			UIView *view = [self.delegate shouldBeVisible:index];
			[self.visibleViews addObject:view];
		}
	}
	
    self.minimumVisibleIndex = minimumVisible;
	self.maximumVisibleIndex = maximumVisible - 1;
	
	DDLogVerbose(@"minimum visible: %d, maximum visible: %d", self.minimumVisibleIndex, self.maximumVisibleIndex);
}

@end
