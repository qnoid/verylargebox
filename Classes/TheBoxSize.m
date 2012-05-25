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

@synthesize value;

-(id)init:(CGFloat) aHeight
{
	self = [super init];
	
	if (self) {
		value = aHeight;
	}	
	
return self;
}

-(NSInteger)floorIndexOf:(CGPoint)point
{
	NSInteger visibleWindowStart = point.y;
	
return floor(visibleWindowStart / value);
}

-(NSInteger)ceilIndexOf:(CGRect)rect
{
	NSInteger visibleWindowStart = rect.origin.y;
	NSInteger visibleWindowHeight = CGRectGetHeight(rect);
	
return ceilf((visibleWindowStart + visibleWindowHeight) / value);
}

- (CGPoint)ceilOriginOf:(CGRect)bounds toContentSize:(CGSize)contentSize
{
    NSUInteger originY = MIN(CGRectGetMinY(bounds) + bounds.size.height, contentSize.height) - bounds.size.height;

return CGPointMake(CGRectGetWidth(bounds), originY);
}

-(CGRect)frameOf:(CGRect)bounds atIndex:(NSUInteger)index {
return CGRectMake(bounds.origin.x, index * self.value, bounds.size.width, self.value);
}

-(NSString *) description{
return [NSString stringWithFormat:@"%f", value];
}

@end

@implementation TheBoxWidth

+(TheBoxWidth*) newWidth:(CGFloat)width{
    return [[TheBoxWidth alloc] init:width];
}

@synthesize value;

-(id)init:(CGFloat) aWidth
{
	self = [super init];
	
	if (self) {
		value = aWidth;
	}	
	
return self;
}

-(NSInteger)floorIndexOf:(CGPoint)point{
return floor(point.x / value);
}

-(NSInteger)ceilIndexOf:(CGRect)rect
{
	NSInteger visibleWindowStart = CGRectGetMinX(rect);
	NSInteger visibleWindowWidth = CGRectGetWidth(rect);
	
return ceilf((visibleWindowStart + visibleWindowWidth) / value);
}

- (CGPoint)ceilOriginOf:(CGRect)bounds toContentSize:(CGSize)contentSize
{
    NSUInteger originX = MIN(CGRectGetMinX(bounds) + bounds.size.width, contentSize.width) - bounds.size.width;

return CGPointMake(originX, CGRectGetHeight(bounds));
}

-(CGRect)frameOf:(CGRect)bounds atIndex:(NSUInteger)index {
return CGRectMake(index * self.value, bounds.origin.y, self.value, bounds.size.width);
}

-(NSString *) description{
return [NSString stringWithFormat:@"%f", value];
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
