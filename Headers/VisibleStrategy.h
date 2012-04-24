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

typedef NSInteger(^MaximumVisibleIndexPrecondition)(NSInteger, NSInteger);

CG_INLINE
MaximumVisibleIndexPrecondition acceptMaximumVisibleIndex()
{
    MaximumVisibleIndexPrecondition precondition = ^(NSInteger currentMaximumVisibleIndex, NSInteger maximumVisibleIndex){
        return maximumVisibleIndex;
    };
    
    return precondition;
}

CG_INLINE
MaximumVisibleIndexPrecondition ceilMaximumVisibleIndexAt(NSInteger ceil)
{
    MaximumVisibleIndexPrecondition precondition = ^(NSInteger currentMaximumVisibleIndex, NSInteger maximumVisibleIndex)
    {
        if(maximumVisibleIndex > ceil){
            return ceil;
        }
        
        return maximumVisibleIndex;
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
 This method should be called prior to calling #layoutSubviews: to avoid wasting cycles. 
 
 @parem the bounds of the view
 @return true if #layoutSubviews: must be called
 */
- (BOOL)needsLayoutSubviews:(CGRect) bounds;

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
-(void)maximumVisibleIndexShould:(MaximumVisibleIndexPrecondition)conformToPrecondition;

-(void)maximumVisibleIndexShould:(MaximumVisibleIndexPrecondition)conformToPrecondition;

-(CGRect)visibleBounds:(CGRect)bounds withinContentSize:(CGSize)contentSize;


@property(nonatomic, unsafe_unretained) id<VisibleStrategyDelegate> delegate;

@required
@property(nonatomic, retain) NSMutableSet *visibleViews;
@property(nonatomic, assign) NSInteger minimumVisibleIndex;
@property(nonatomic, assign) NSInteger maximumVisibleIndex;

@end
