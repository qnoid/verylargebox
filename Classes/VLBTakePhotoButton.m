//
//  VLBTakePhotoButton.m
//  verylargebox
//
//  Created by Markos Charatzas on 29/07/2013.
//  Copyright (c) 2013 verylargebox.com. All rights reserved.
//

#import "VLBTakePhotoButton.h"
#import "VLBMacros.h"

@implementation VLBTakePhotoButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    VLB_IF_NOT_SELF_RETURN_NIL();
    VLB_LOAD_VIEW();
    
    return self;
}

-(void)addTarget:(id)target action:(SEL)action
{
    [self.button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}
@end
