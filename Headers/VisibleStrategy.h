/*
 *  Copyright 2010 The Box
 *  All rights reserved.
 *
 *  This file is part of TheBox
 *
 *  Created by Markos Charatzas <[firstname.lastname@gmail.com]> on 27/11/10.
 *  Contributor(s): .-
 */
#import <UIKit/UIKit.h>

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
VisibleIndexPrecondition floorVisibleIndexAt(NSInteger ceil)
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
VisibleIndexPrecondition ceilVisibleIndexAt(NSInteger ceil)
{
    VisibleIndexPrecondition precondition = ^(NSInteger currentVisibleIndex, NSInteger visibleIndex)
    {
        if(visibleIndex > ceil){
            return ceil;
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

@end


@protocol VisibleStrategy<NSObject>

- (NSUInteger)minimumVisible:(CGPoint)bounds;

- (NSUInteger)maximumVisible:(CGRect)bounds;

-(BOOL)isVisible:(NSInteger) index;

/**
 Normalises the bounds to indexes based on the strategy's dimension.
 
 For every visible index calculated given the bounds a call to VisibleStrategyDelegate#shouldBeVisible
 will be made if the index is not already visible from a prior call.
 
 @postcondion minimumVisibleIndex will be set 
 @postcondion maximumVisibleIndex will be set 
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

-(CGRect)visibleBounds:(CGRect)bounds withinContentSize:(CGSize)contentSize;


@property(nonatomic, unsafe_unretained) id<VisibleStrategyDelegate> delegate;

@required
@property(nonatomic, retain) NSMutableSet *visibleViews;
@property(nonatomic, assign) NSInteger minimumVisibleIndex;
@property(nonatomic, assign) NSInteger maximumVisibleIndex;

@end
