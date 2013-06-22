//
//  VLBProgressView.m
//  thebox
//
//  Created by Markos Charatzas on 21/04/2013.
//  Copyright (c) 2013 (verylargebox.com). All rights reserved.
//

#import "VLBProgressView.h"
#import "VLBMacros.h"
#import "VLBColors.h"

@implementation VLBProgressView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) {
        return nil;
    }

    VLB_LOAD_VIEW();
    self.progressView.progressTintColor = [VLBColors colorPrimaryBlue];
    self.progressView.trackTintColor = [VLBColors color0102161];
return self;
}

@end
