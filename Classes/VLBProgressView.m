//
//  VLBProgressView.m
//  verylargebox
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

    VLB_IF_NOT_SELF_RETURN_NIL();
    VLB_LOAD_VIEW();
    
    self.progressView.progressTintColor = [VLBColors colorPrimaryBlue];
    self.progressView.trackTintColor = [VLBColors color0102161];
return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    VLB_IF_NOT_SELF_RETURN_NIL();
    VLB_LOAD_VIEW();
    
    self.progressView.progressTintColor = [VLBColors colorPrimaryBlue];
    self.progressView.trackTintColor = [VLBColors color0102161];
    
return self;
}

- (void)setProgress:(float)progress animated:(BOOL)animated {
    [self.progressView setProgress:progress animated:animated];
}

@end
