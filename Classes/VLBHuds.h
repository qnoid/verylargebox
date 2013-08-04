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

extern void vlb_animate(UIView *view);

extern VLBProgressHUDBlock const VLB_PROGRESS_HUD_CUSTOM_VIEW_IDCARD;
extern VLBProgressHUDBlock const VLB_PROGRESS_HUD_CUSTOM_VIEW_IPHONE;
extern VLBProgressHUDBlock const VLB_PROGRESS_HUD_CUSTOM_VIEW_CIRCLE_NO;
extern VLBProgressHUDBlock const VLB_PROGRESS_HUD_CUSTOM_VIEW_LOCATION_ERROR_REFRESH;
extern VLBProgressHUDBlock const VLB_PROGRESS_HUD_CUSTOM_VIEW_LOCATION_ERROR_TARGET;
extern VLBProgressHUDBlock const VLB_PROGRESS_HUD_CUSTOM_VIEW_RADAR;
extern VLBProgressHUDBlock const VLB_PROGRESS_HUD_CUSTOM_VIEW_CAMERA;
extern VLBProgressHUDBlock const VLB_PROGRESS_HUD_CUSTOM_VIEW_LOCATION_ARROW;
extern VLBProgressHUDBlock const VLB_PROGRESS_HUD_CUSTOM_VIEW_SEARCH;
extern VLBProgressHUDBlock const VLB_PROGRESS_HUD_CUSTOM_VIEW_ENVELOPE;

@interface VLBHuds : NSObject

+(MBProgressHUD*)newWithView:(UIView*)view config:(VLBProgressHUDBlock)block;
+(MBProgressHUD*)newWithView:(UIView*)view;
+(MBProgressHUD*)newWithViewLocationArrow:(UIView*)view;
+(MBProgressHUD*)newWithViewCamera:(UIView*)view locality:(NSString*)locality;
+(MBProgressHUD*)newWithViewRadar:(UIView*)view;
+(MBProgressHUD*)newWithViewSearch:(UIView*)view query:(NSString*)query;
+(MBProgressHUD*)newOnDidFailOnVerifyWithError:(UIView*)view;
+(MBProgressHUD*)newViewWithIdCard:(UIView*)view;
+(MBProgressHUD*)newOnDidEnterEmail:(UIView*)view email:(NSString *)email;
+(MBProgressHUD*)newOnDidSucceedWithRegistration:(UIView*)view email:(NSString *)email residence:(NSString *)residence;
+(MBProgressHUD*)newOnDidSignIn:(UIView*)view email:(NSString*)email;
+(MBProgressHUD*)newSignOutViewWithIdCard:(UIView*)view;
+(MBProgressHUD*)newNoStoresFound:(UIView*)view;
@end
