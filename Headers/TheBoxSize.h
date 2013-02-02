/*
 *  Copyright 2010 The Box
 *  All rights reserved.
 *
 *  This file is part of TheBox
 *
 *  Created by Markos Charatzas (@qnoid) on 13/12/10.
 *  Contributor(s): .-
 */
#import <Foundation/Foundation.h>

NS_INLINE
CGPoint foo(CGFloat foo, CGFloat value)
{
    float average = value / 2.0;
    float mod = fmod(foo, value);
    float whole = foo - mod;
    
    if(mod <= average){
        return CGPointMake(whole, foo);
    }
    
return CGPointMake(whole + value, foo);
}
/*
 * Represents a dimension on the size
 */
@protocol TheBoxDimension <NSObject>

@property(nonatomic, assign) CGFloat value;

/*
 * The minimum visible must take into account cells that are partially visible
 * 
 * e.g.
 *
 *	for visible bounds where with a width of 320 and a cell size of 160 where
 *		x = 360
 *		x + width = 680 (up to where is visible)
 *
 *	max = 360 / 160 = 2.25 means that some of 2 is also visible,
 *	therefore floor the float 
 *
 * @return the minimum number of times the size fits within the visible bounds
 */
-(NSUInteger)floorIndexOf:(CGPoint)point;

/*
 * The maximum visible must take into account cells that are partially visible
 *
 * e.g.
 *
 *	for visible bounds where with a width of 320 and a cell size of 160 where
 *		x = 360
 *		x + width = 680 (up to where is visible)
 *
 *	max = 680 / 160 = 3.25 means that some of 4 is also visible,
 *	therefore ceil the float 
 *
 * @param visibleBounds should have zero or positive values for each of the x,y,width,height
 * @return the maximum number of times the size fits within the visible bounds
 */
-(NSUInteger)ceilIndexOf:(CGRect)rect;

-(CGPoint)ceilOriginOf:(CGRect)bounds toContentSize:(CGSize)contentSize;

-(CGRect)frameOf:(CGRect) bounds atIndex:(NSUInteger)index;

/*
 Dimension implementations set the point closer
 to their whole number like a piecewise function where
 
 e.g.
    For a value of 100
 
 f(point.x) =   {   0 : 0   < point.x ≤ 50
                { 100 : 50  < point.x ≤ 100
 
 @param point
 */
-(void)moveCloserToWhole:(inout CGPoint*)point;

@end

@interface TheBoxHeight : NSObject <TheBoxDimension>
{
@private
    CGFloat value;
}

+(TheBoxHeight*) newHeight:(CGFloat)height;

-(id)init:(CGFloat) height;
-(NSInteger)floorIndexOf:(CGPoint)point;
-(NSInteger)ceilIndexOf:(CGRect)rect;
@end

@interface TheBoxWidth : NSObject <TheBoxDimension>
{
@private
    CGFloat value;
}
+(TheBoxWidth*) newWidth:(CGFloat)width;

-(id)init:(CGFloat) width;
-(NSInteger)floorIndexOf:(CGPoint)point;
-(NSInteger)ceilIndexOf:(CGRect)rect;
@end

@protocol TheBoxSize <NSObject>

@property(nonatomic, assign) CGSize size;

/*
 * What's the required content size for a fixed width, 
 * given a height and the number of rows
 *
 *
 * @param noOfRows the total number of rows
 * @param height the height for each row
 * @return the content size the content size required to fit all the rows for the
 *		given height
 */
-(CGSize)sizeOf:(NSUInteger)noOfRows size:(CGFloat)size;

-(id<TheBoxDimension>)dimension;

@end

@interface TheBoxSizeInWidth : NSObject <TheBoxSize>
{
	@private
		CGSize size;
}

@property(nonatomic, assign) CGSize size;

-(id)initWithSize:(CGSize) size;

@end

@interface TheBoxSizeInHeight : NSObject <TheBoxSize>
{
    @private
        CGSize size;
}

@property(nonatomic, assign) CGSize size;

-(id)initWithSize:(CGSize) size;

@end
