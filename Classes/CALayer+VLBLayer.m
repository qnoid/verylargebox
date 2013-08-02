//
//  CALayer+VLBLayer.m
//  verylargebox
//
//  Created by Markos Charatzas on 02/08/2013.
//  Copyright (c) 2013 verylargebox.com. All rights reserved.
//

#import "CALayer+VLBLayer.h"

VLBBasicAnimationBlock const VLBBasicAnimationBlockRotate = ^(CABasicAnimation *basicAnimation){
    basicAnimation.timingFunction = [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionLinear];
    basicAnimation.fromValue = @(0);
    basicAnimation.toValue = @(2 * M_PI);
    basicAnimation.duration = 1.0;
    basicAnimation.repeatCount = HUGE_VALF;
};

@implementation CALayer (VLBLayer)

-(void)vlb_rotate:(VLBBasicAnimationBlock) animationBlock
{
    CABasicAnimation *basicAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    
    VLBBasicAnimationBlockRotate(basicAnimation);
    
    [self addAnimation:basicAnimation forKey:@"transform.rotation.z"];
}
-(void)vlb_stopRotate
{
    [self removeAnimationForKey:@"transform.rotation.z"];
}

@end
