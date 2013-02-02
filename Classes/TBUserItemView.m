//
//  TBUserItemView.m
//  thebox
//
//  Created by Markos Charatzas on 02/02/2013.
//  Copyright (c) 2013 TheBox. All rights reserved.
//

#import "TBUserItemView.h"

@implementation TBUserItemView

+(instancetype)userItemViewWithOwner:(id)owner
{
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([TBUserItemView class]) owner:owner options:nil];
    
return (TBUserItemView*)[views objectAtIndex:0];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
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
