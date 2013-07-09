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
extern VLBProgressHUDBlock const VLB_PROGRESS_HUD_CUSTOM_VIEW_LOCATION_ERROR_REFRESH;
extern VLBProgressHUDBlock const VLB_PROGRESS_HUD_CUSTOM_VIEW_LOCATION_ERROR_TARGET;
extern VLBProgressHUDBlock const VLB_PROGRESS_HUD_CUSTOM_VIEW_CAMERA;
extern VLBProgressHUDBlock const VLB_PROGRESS_HUD_CUSTOM_VIEW_LOCATION_ARROW;

@interface VLBHuds : NSObject

+(MBProgressHUD*)newWithView:(UIView*)view config:(VLBProgressHUDBlock)block;
+(MBProgressHUD*)newWithView:(UIView*)view;
+(MBProgressHUD*)newWithViewLocationArrow:(UIView*)view;
+(MBProgressHUD*)newWithViewCamera:(UIView*)view locality:(NSString*)locality;

@end
