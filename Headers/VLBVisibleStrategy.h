/*
 *  Copyright 2010 The Box
 *  All rights reserved.
 *
 *  This file is part of TheBox
 *
 *  Created by Markos Charatzas (@qnoid) on 27/11/10.
 *  Contributor(s): .-
 */
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "VLBSize.h"

typedef NSInteger(^VisibleIndexPrecondition)(NSInteger, NSInteger);

CG_INLINE
VisibleIndexPrecondition acceptAnyVisibleIndex()
{
    VisibleIndexPrecondition precondition = ^(NSInteger currentVisibleIndex, NSInteger visibleIndex){
        return visibleIndex;
    };
    
    return precondition;
}

CG_INLINE
VisibleIndexPrecondition ceilVisibleIndexAt(NSInteger ceil)
{
    VisibleIndexPrecondition precondition = ^(NSInteger currentVisibleIndex, NSInteger visibleIndex)
    {
        if(visibleIndex < ceil){
            return ceil;
        }
        
        return visibleIndex;
    };
    
    return precondition;
}

CG_INLINE
VisibleIndexPrecondition floorVisibleIndexAt(NSInteger floor)
{
    VisibleIndexPrecondition precondition = ^(NSInteger currentVisibleIndex, NSInteger visibleIndex)
    {
        if(visibleIndex > floor){
            return floor;
        }
        
        return visibleIndex;
    };
    
    return precondition;
}

@protocol VisibleStrategyDelegate<NSObject>

/*
 * @return the view corresponding to the index
 */
-(UIView *)shouldBeVisible:(int)index;

/**
 @param minimumVisibleIndex the minimum visible index to appear in the next cycle
 @param maximumVisibleIndex the maximum visible index to appear in the next cycle
 */
-(void)viewsShouldBeVisibleBetween:(NSUInteger)minimumVisibleIndex to:(NSUInteger)maximumVisibleIndex;

@end


@protocol VLBVisibleStrategy <NSObject>

- (NSInteger)minimumVisible:(CGPoint)bounds;

- (NSInteger)maximumVisible:(CGRect)bounds;

-(BOOL)isVisible:(NSInteger) index;

/**
 Calculates indexes based on bounds.
 
 For every visible index a call to VisibleStrategyDelegate#shouldBeVisible
 will be made if the index is not already visible from a prior call.
  
 @postcondion the minimum visible index is set
 @postcondion the maximum visible index is set to maximumVisibleIndex - 1
 @param bounds the visible bounds
 @see newVisibleStrategyOn:
 */
- (void)layoutSubviews:(CGRect) bounds;

/**
 Applies a precondition to the maximum visible index. If the maximum visible index as calculated by 
 the bounds given in willAppear: doesn't satisfy the precondition, the last maximum visible index is used.
 
 @param conformToPrecondition the precondition that the maximum visible index should apply to
 @see ceilMaximumVisibleIndexAt
 */
-(void)minimumVisibleIndexShould:(VisibleIndexPrecondition)conformToPrecondition;

-(void)maximumVisibleIndexShould:(VisibleIndexPrecondition)conformToPrecondition;

@property(nonatomic, unsafe_unretained) id<VisibleStrategyDelegate> delegate;

@required
@property(nonatomic, retain) NSMutableSet *visibleViews;
@property(nonatomic, assign) NSInteger minimumVisibleIndex;
@property(nonatomic, assign) NSInteger maximumVisibleIndex;

@end

#define VLB_MINIMUM_VISIBLE_INDEX    NSIntegerMax
#define VLB_MAXIMUM_VISIBLE_INDEX    NSIntegerMin
/*
 * Use to normalise the bounds to an index of what's to show while also
 * keeping track of the minimum and maximum visible view based on it's index
 */
@interface VLBVisibleStrategy : NSObject <VLBVisibleStrategy>
{
@private
    NSInteger minimumVisibleIndex;
    NSInteger maximumVisibleIndex;
}
@property(nonatomic) id<VLBDimension> dimension;

+(VLBVisibleStrategy *)newVisibleStrategyOnWidth:(CGFloat) width;
+(VLBVisibleStrategy *)newVisibleStrategyOnHeight:(CGFloat) height;
+(VLBVisibleStrategy *)newVisibleStrategyOn:(id<VLBDimension>) dimension;
+(VLBVisibleStrategy *)newVisibleStrategyFrom:(VLBVisibleStrategy *) visibleStrategy;

- (NSInteger)minimumVisible:(CGPoint)bounds;

- (NSInteger)maximumVisible:(CGRect)bounds;

@end
