//
//  CALayer+VLBLayer.h
//  verylargebox
//
//  Created by Markos Charatzas on 02/08/2013.
//  Copyright (c) 2013 verylargebox.com. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

typedef void(^VLBBasicAnimationBlock)(CABasicAnimation *basicAnimation);

extern VLBBasicAnimationBlock const VLBBasicAnimationBlockRotate;

@interface CALayer (VLBLayer)

-(void)vlb_rotate:(VLBBasicAnimationBlock) animationBlock;
-(void)vlb_stopRotate;

@end
