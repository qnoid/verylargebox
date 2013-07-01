//
//  VLBItemView.m
//  verylargebox
//
//  Created by Markos Charatzas on 10/01/2013.
//  Copyright (c) 2013 (verylargebox.com). All rights reserved.
//

#import "VLBItemView.h"
#import "VLBMacros.h"

@implementation VLBItemView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    VLB_IF_NOT_SELF_RETURN_NIL()
    VLB_LOAD_VIEW()

return self;
}

//
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}

@end
