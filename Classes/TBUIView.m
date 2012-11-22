/*
 *  Copyright 2011 TheBox
 *  All rights reserved.
 *
 *  This file is part of TheBox
 *
 *  Created by Markos Charatzas (@qnoid) on 19/05/2012.
 *  Contributor(s): .-
 */
#import "TBUIView.h"

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
