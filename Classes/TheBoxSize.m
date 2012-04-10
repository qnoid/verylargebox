/*
 *  Copyright 2010 The Box
 *  All rights reserved.
 *
 *  This file is part of TheBox
 *
 *  Created by Markos Charatzas <[firstname.lastname@gmail.com]> on 13/12/10.
 *  Contributor(s): .-
 */
#import "TheBoxSize.h"

@implementation TheBoxHeight

-(id)init:(CGFloat) aHeight
{
	self = [super init];
	
	if (self) {
		height = aHeight; 
	}	
	
return self;
}

-(NSUInteger)minimumVisible:(CGRect) visibleBounds
{
	NSUInteger visibleWindowStart = visibleBounds.origin.y;
	
return floor(visibleWindowStart / height);	
}

-(NSUInteger)maximumVisible:(CGRect) visibleBounds
{
	NSUInteger visibleWindowStart = visibleBounds.origin.y;
	NSInteger visibleWindowHeight = CGRectGetHeight(visibleBounds);
	
return ceilf((visibleWindowStart + visibleWindowHeight) / height);	
}

-(NSString *) description{
return [NSString stringWithFormat:@"%f", height];
}

@end

@implementation TheBoxWidth

-(id)init:(CGFloat) aWidth
{
	self = [super init];
	
	if (self) {
		width = aWidth; 
	}	
	
return self;
}

-(NSUInteger)minimumVisible:(CGRect) visibleBounds
{
	NSUInteger visibleWindowStart = CGRectGetMinX(visibleBounds);
	
return floor(visibleWindowStart / width);
}

-(NSUInteger)maximumVisible:(CGRect) visibleBounds
{
	NSUInteger visibleWindowStart = CGRectGetMinX(visibleBounds);
	NSUInteger visibleWindowWidth = CGRectGetWidth(visibleBounds);
	
return ceilf((visibleWindowStart + visibleWindowWidth) / width);
}

-(NSString *) description{
return [NSString stringWithFormat:@"%f", width];
}

@end


@implementation TheBoxSize

+(TheBoxHeight*) newHeight:(CGFloat)height{
return [[TheBoxHeight alloc] init:height];
}

+(TheBoxWidth*) newWidth:(CGFloat)width{
return [[TheBoxWidth alloc] init:width];
}

@synthesize size;

-(id)initWithSize:(CGSize) theSize
{
	self = [super init];
	
	if (self) 
	{
		self.size = theSize;
	}
	
return self;
}

/*
 * @return a dimension on height
 */
-(id<TheBoxDimension>)height{
return [[TheBoxHeight alloc] init:self.size.height];
}

/*
 * @return a dimension on width
 */
-(id<TheBoxDimension>)width{
return [[TheBoxWidth alloc] init:self.size.width];	
}

-(CGSize)sizeOf:(NSUInteger)noOfRows height:(CGFloat)height
{
	float noOfRowsInHeight = self.size.height / height;

	if(noOfRowsInHeight == 0){
		return CGSizeZero;
	}
	
return CGSizeMake(
		self.size.width, 
		(float)noOfRows / (float)noOfRowsInHeight * self.size.height);
}

-(CGSize)sizeOf:(NSUInteger)noOfColumns width:(CGFloat)width
{
	float nofOfColumnsInWidth = self.size.width / width;
	
	if(nofOfColumnsInWidth == 0){
		return CGSizeZero;
	}
	
return CGSizeMake(
		  (float)noOfColumns / (float)nofOfColumnsInWidth * self.size.width,
		  self.size.height);
}

@end
