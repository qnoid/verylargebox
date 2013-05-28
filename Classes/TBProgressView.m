//
//  TBProgressView.m
//  thebox
//
//  Created by Markos Charatzas on 21/04/2013.
//  Copyright (c) 2013 TheBox. All rights reserved.
//

#import "TBProgressView.h"
#import "TBMacros.h"

@implementation TBProgressView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) {
        return nil;
    }

    loadView();
    
return self;
}

@end
