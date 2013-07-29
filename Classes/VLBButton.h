//
//  UIButton+VLBButton.h
//  verylargebox
//
//  Created by Markos Charatzas on 18/11/2012.
//  Copyright (c) 2012 (verylargebox.com). All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "VLBColors.h"
#import "VLBView.h"

/**
 Handles a callback of a UIControlEvents
 */
typedef void(^VLBButtonOnTouch)(UIButton *button);

extern VLBButtonOnTouch const VLBButtonOnTouchNone;

NS_INLINE
VLBButtonOnTouch makeButton(UIColor* color) {
    return ^(UIButton *button) {
        button.layer.backgroundColor = color.CGColor;
    };
}

NS_INLINE
VLBButtonOnTouch makeButtonWhite() {
    return makeButton([UIColor whiteColor]);
}

/**
 A UIButton that adds expressive declarations to any properties affecting its style.
 
 Allows registering blocks to handle UIControlEvent(s).
 @see VLBButton
 */
@protocol VLBButton <NSObject>

/**
 Sets the block to call on touch down events.
 
 Subsequent call will override the existing block.
 
 @param doo the block to call on touch down events
 */
-(void)onTouchDown:(VLBButtonOnTouch)doo;

-(void)onTouchUpInside:(VLBButtonOnTouch)doo;

/**
 Sets the block to call on touch up events.
 
 Subsequent call will override the existing block.
 
 @param doo the block to call on touch up events
 */
-(void)onTouchUp:(VLBButtonOnTouch)doo;

@end

@interface VLBButton : UIButton <VLBButton>
@property(nonatomic, weak) IBOutlet NSObject<VLBViewDrawRectDelegate> *delegate;

/**
 Overrides drawRect
 */
- (void)drawRect:(CGRect)rect;
@end
