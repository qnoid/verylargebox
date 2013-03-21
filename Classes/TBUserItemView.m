//
//  TBUserItemView.m
//  thebox
//
//  Created by Markos Charatzas on 02/02/2013.
//  Copyright (c) 2013 TheBox. All rights reserved.
//

#import "TBUserItemView.h"

@implementation TBUserItemView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) {
        return nil;
    }
    
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([TBUserItemView class])
                                                   owner:self
                                                 options:nil];

    [self addSubview:[views objectAtIndex:0]];
    self.didTapOnGetDirectionsButton = tbUserItemViewGetDirectionsNoOp();
    
return self;
}

-(IBAction)didTapOnGetDirectionsButton:(id)sender
{
    self.didTapOnGetDirectionsButton();
}

@end
