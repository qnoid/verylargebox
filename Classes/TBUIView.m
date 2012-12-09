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

@implementation UIView (TBViewBorder)

- (id<TBViewBorder>)border {
    return [[self borderWidth:1.0f] borderColor:[UIColor blackColor].CGColor];
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
