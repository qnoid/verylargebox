//
//  UIButton+TBButton.h
//  thebox
//
//  Created by Markos Charatzas on 18/11/2012.
//  Copyright (c) 2012 TheBox. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "TBColors.h"
#import "TBView.h"

/**
 Handles a callback of a UIControlEvents
 */
typedef void(^TBButtonOnTouch)(UIButton *button);

NS_INLINE
TBButtonOnTouch makeButton(UIColor* color) {
    return ^(UIButton *button) {
        button.layer.backgroundColor = color.CGColor;
    };
}

NS_INLINE
TBButtonOnTouch makeButtonWhite() {
    return makeButton([UIColor whiteColor]);
}

/**
 A UIButton that adds expressive declarations to any properties affecting its style.
 
 Allows registering blocks to handle UIControlEvent(s).
 @see TBButton
 */
@protocol TBButton <NSObject>

/**
 Sets the block to call on touch down events.
 
 Subsequent call will override the existing block.
 
 @param doo the block to call on touch down events
 */
-(void)onTouchDown:(TBButtonOnTouch)doo;

-(void)onTouchUpInside:(TBButtonOnTouch)doo;

/**
 Sets the block to call on touch up events.
 
 Subsequent call will override the existing block.
 
 @param doo the block to call on touch up events
 */
-(void)onTouchUp:(TBButtonOnTouch)doo;

@end

@interface TBButton : UIButton <TBButton>
@property(nonatomic, weak) IBOutlet NSObject<TBViewDrawRectDelegate> *delegate;

/**
 Overrides drawRect
 */
- (void)drawRect:(CGRect)rect;
@end
