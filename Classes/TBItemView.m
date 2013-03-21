//
//  TBItemView.m
//  thebox
//
//  Created by Markos Charatzas on 10/01/2013.
//  Copyright (c) 2013 TheBox. All rights reserved.
//

#import "TBItemView.h"

@implementation TBItemView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) {
        return nil;
    }
    
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class])
                                                   owner:self
                                                 options:nil];
    
    [self addSubview:views[0]];

return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
@end
