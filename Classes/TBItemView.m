//
//  TBItemView.m
//  thebox
//
//  Created by Markos Charatzas on 10/01/2013.
//  Copyright (c) 2013 TheBox. All rights reserved.
//

#import "TBItemView.h"

@implementation TBItemView

+(instancetype)itemViewWithOwner:(id)owner
{
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"TBItemView" owner:owner options:nil];
    
    return (TBItemView*)[views objectAtIndex:0];
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
