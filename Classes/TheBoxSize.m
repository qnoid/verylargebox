/*
 *  Copyright 2010 The Box
 *  All rights reserved.
 *
 *  This file is part of TheBox
 *
 *  Created by Markos Charatzas (@qnoid) on 13/12/10.
 *  Contributor(s): .-
 */
#import "TheBoxSize.h"

@implementation TheBoxHeight

+(TheBoxHeight*) newHeight:(CGFloat)height{
    return [[TheBoxHeight alloc] init:height];
}

-(id)init:(CGFloat) aHeight
{
	self = [super init];
	
	if (self) {
		height = aHeight; 
	}	
	
return self;
}

-(NSInteger)minimumVisible:(CGPoint)point
{
	NSInteger visibleWindowStart = point.y;
	
return floor(visibleWindowStart / height);	
}

-(NSInteger)maximumVisible:(CGRect)visibleBounds
{
	NSInteger visibleWindowStart = visibleBounds.origin.y;
	NSInteger visibleWindowHeight = CGRectGetHeight(visibleBounds);
	
return ceilf((visibleWindowStart + visibleWindowHeight) / height);	
}

- (CGPoint)ceilOriginOf:(CGRect)bounds toContentSize:(CGSize)contentSize
{
    NSUInteger originY = MIN(CGRectGetMinY(bounds) + bounds.size.height, contentSize.height) - bounds.size.height;

return CGPointMake(CGRectGetWidth(bounds), originY);
}

-(NSString *) description{
return [NSString stringWithFormat:@"%f", height];
}

@end

@implementation TheBoxWidth

+(TheBoxWidth*) newWidth:(CGFloat)width{
    return [[TheBoxWidth alloc] init:width];
}

-(id)init:(CGFloat) aWidth
{
	self = [super init];
	
	if (self) {
		width = aWidth; 
	}	
	
return self;
}

-(NSInteger)minimumVisible:(CGPoint)point{
return floor(point.x / width);
}

-(NSInteger)maximumVisible:(CGRect)visibleBounds
{
	NSInteger visibleWindowStart = CGRectGetMinX(visibleBounds);
	NSInteger visibleWindowWidth = CGRectGetWidth(visibleBounds);
	
return ceilf((visibleWindowStart + visibleWindowWidth) / width);
}

- (CGPoint)ceilOriginOf:(CGRect)bounds toContentSize:(CGSize)contentSize
{
    NSUInteger originX = MIN(CGRectGetMinX(bounds) + bounds.size.width, contentSize.width) - bounds.size.width;

return CGPointMake(originX, CGRectGetHeight(bounds));
}

-(NSString *) description{
return [NSString stringWithFormat:@"%f", width];
}

@end


@implementation TheBoxSizeInHeight

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

-(CGSize)sizeOf:(NSUInteger)noOfRows size:(CGFloat)height
{
    if(noOfRows == 0){
		return CGSizeZero;
	}
    
	float noOfRowsInHeight = self.size.height / height;
	
    return CGSizeMake(
                      self.size.width, 
                      ((float)noOfRows / (float)noOfRowsInHeight) * self.size.height);
}

/*
 * @return a dimension on height
 */
-(id<TheBoxDimension>)dimension{
return [[TheBoxHeight alloc] init:self.size.height];
}

@end

@implementation TheBoxSizeInWidth

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

-(CGSize)sizeOf:(NSUInteger)noOfColumns size:(CGFloat)width
{
    if(noOfColumns == 0){
		return CGSizeZero;
	}

	float nofOfColumnsInWidth = self.size.width / width;
	
return CGSizeMake(
		  ((float)noOfColumns / (float)nofOfColumnsInWidth) * self.size.width,
		  self.size.height);
}

/*
 * @return a dimension on width
 */
-(id<TheBoxDimension>)dimension{
    return [[TheBoxWidth alloc] init:self.size.width];	
}

@end
