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
TBButtonOnTouch makeButtonDarkOrange() {
    return makeButton([TBColors colorDarkOrange]);
}

NS_INLINE
TBButtonOnTouch makeButtonWhite() {
    return makeButton([UIColor whiteColor]);
}

/**
 Groups related border properties together and allows chaining.
*/
@protocol TBButtonBorder

/**
 Sets the border width 
 
 @param width the border width
 @return self for chaining
 @see CALayer#borderWidth
 */
-(id<TBButtonBorder>)borderWidth:(CGFloat)width;

/**
 Sets the border color
 
 @param color the border color
 @return self for chaining
 @see CALayer#borderColor
 */
-(id<TBButtonBorder>)borderColor:(CGColorRef)color;
@end
/**
 A UIButton that adds expressive declarations to any properties affecting its style.

 Allows registering blocks to handle UIControlEvent(s).
*/
@interface TBButton : UIButton

/**
 Sets the corner radius
 
 @param cornerRadius the corner radius
 @return self for chaining
 @see CALayer#cornerRadius
 */
-(TBButton*)cornerRadius:(CGFloat)cornerRadius;

/**
 Access to common properties related to the border

 default border width 1.0f
 default border color black

 @return a TBButtonBorder type to set any border properties
*/
-(id<TBButtonBorder>)border;

/**
 Sets the block to call on touch down events.
 
 Subsequent call will override the existing block.
 
 @param doo the block to call on touch down events
 */
-(void)onTouchDown:(TBButtonOnTouch)doo;

/**
 Sets the block to call on touch up events.

 Subsequent call will override the existing block.

 @param doo the block to call on touch up events
 */
-(void)onTouchUp:(TBButtonOnTouch)doo;
@end
