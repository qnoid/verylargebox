//
// Copyright 2013 TheBox
// All rights reserved.
//
// This file is part of thebox
//
// Created by Markos Charatzas on 30/05/2013.
//
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"

typedef MBProgressHUD*(^VLBProgressHUDBlock)(MBProgressHUD *hud);

extern VLBProgressHUDBlock const VLB_PROGRESS_HUD_CUSTOM_VIEW_CIRCLE_NO;

@interface VLBHuds : NSObject

+(MBProgressHUD*)newWithView:(UIView*)view config:(VLBProgressHUDBlock)block;

@end
