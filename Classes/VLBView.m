/*
 *  Copyright 2011 TheBox
 *  All rights reserved.
 *
 *  This file is part of TheBox
 *
 *  Created by Markos Charatzas (@qnoid) on 19/05/2012.
 *  Contributor(s): .-
 */
#import <QuartzCore/QuartzCore.h>
#import "VLBView.h"
#import "VLBColors.h"
#import "VLBMacros.h"

@implementation UIView (VLBView)

- (id<VLBViewBorder>)vlb_border {
    return [[self vlb_borderWidth:1.0f] vlb_borderColor:[UIColor blackColor].CGColor];
}

-(id<VLBViewBorder>)vlb_bottomBorder:(UIColor*)color{
    CALayer *topBorder = [CALayer layer];
    topBorder.frame = CGRectMake(0.0f, 44.0f, 160.0f, 2.0f);
    topBorder.backgroundColor = color.CGColor;
    [self.layer addSublayer:topBorder];
return self;
}

- (id<VLBViewBorder>)vlb_borders:(UIColor*)color
{
    CALayer *leftBorder = [CALayer layer];
    leftBorder.frame = CGRectMake(0.0f, 0.0f, 2.0f, 44.0f);
    leftBorder.backgroundColor = color.CGColor;

    CALayer *topBorder = [CALayer layer];
    topBorder.frame = CGRectMake(0.0f, 0.0f, 160.0f, 2.0f);
    topBorder.backgroundColor = color.CGColor;

    CALayer *rightBorder = [CALayer layer];
    rightBorder.frame = CGRectMake(160.0f, 0.0f, 2.0f, 44.0f);
    rightBorder.backgroundColor = color.CGColor;

    [self.layer addSublayer:leftBorder];
    [self.layer addSublayer:topBorder];
    [self.layer addSublayer:rightBorder];
return self;
}

- (id<VLBViewBorder>)vlb_borderWidth:(CGFloat)width
{
    self.layer.borderWidth = width;
    return self;
}

- (id<VLBViewBorder>)vlb_borderColor:(CGColorRef)color
{
    self.layer.borderColor = color;
    return self;
}

-(id<VLBViewCorner>)vlb_cornerRadius:(CGFloat)cornerRadius
{
    self.layer.cornerRadius = cornerRadius;
    self.layer.masksToBounds = YES;
    return self;
}

@end

@interface VLBView ()
@end

@implementation VLBView
@end
