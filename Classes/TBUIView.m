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
#import "TBUIView.h"
#import "TBColors.h"

@implementation UIView (TBViewBorder)

- (id<TBViewBorder>)border {
    return [[self borderWidth:1.0f] borderColor:[UIColor blackColor].CGColor];
}

-(id<TBViewBorder>)bottomBorder{
    CALayer *topBorder = [CALayer layer];
    topBorder.frame = CGRectMake(0.0f, 44.0f, 160.0f, 2.0f);
    topBorder.backgroundColor = [TBColors colorDarkOrange].CGColor;
    [self.layer addSublayer:topBorder];
return self;
}

- (id<TBViewBorder>)borders
{
    CALayer *leftBorder = [CALayer layer];
    leftBorder.frame = CGRectMake(0.0f, 0.0f, 2.0f, 44.0f);
    leftBorder.backgroundColor = [TBColors colorDarkOrange].CGColor;

    CALayer *topBorder = [CALayer layer];
    topBorder.frame = CGRectMake(0.0f, 0.0f, 160.0f, 2.0f);
    topBorder.backgroundColor = [TBColors colorDarkOrange].CGColor;

    CALayer *rightBorder = [CALayer layer];
    rightBorder.frame = CGRectMake(160.0f, 0.0f, 2.0f, 44.0f);
    rightBorder.backgroundColor = [TBColors colorDarkOrange].CGColor;

    [self.layer addSublayer:leftBorder];
    [self.layer addSublayer:topBorder];
    [self.layer addSublayer:rightBorder];
return self;
}

- (id<TBViewBorder>)borderWidth:(CGFloat)width
{
    self.layer.borderWidth = width;
    return self;
}

- (id<TBViewBorder>)borderColor:(CGColorRef)color
{
    self.layer.borderColor = color;
    return self;
}
@end

@interface TBUIView ()
-(id)initWithFrame:(CGRect)frame drawRect:(NSObject<TBUIViewDrawRect>*) drawRect;
@end

@implementation TBUIView

-(id)initWithFrame:(CGRect)frame drawRect:(NSObject<TBUIViewDrawRect>*) drawRect
{
    self = [super initWithFrame:frame];
    
    if (!self) {
        return nil;
    }
    
    self.drawRect = drawRect;
    
return self;
}

- (void)drawRect:(CGRect)rect
{
    [self.drawRect drawRect:rect onView:self];
}

@end
