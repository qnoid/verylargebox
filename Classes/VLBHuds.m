//
//  Copyright 2013 TheBox
//  All rights reserved.
//
//  This file is part of thebox
//
//  Created by Markos Charatzas on 30/05/2013.
//

#import "VLBHuds.h"

@implementation VLBHuds


VLBProgressHUDBlock const VLB_PROGRESS_HUD_CUSTOM_VIEW_CIRCLE_NO = ^(MBProgressHUD *hud)
{
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"circle-no.png"]];
    hud.mode = MBProgressHUDModeCustomView;
    
return hud;
};

VLBProgressHUDBlock const VLB_PROGRESS_HUD_CUSTOM_VIEW_LOCATION_ERROR_REFRESH = ^(MBProgressHUD *hud)
{
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"refresh.png"]];
    hud.mode = MBProgressHUDModeCustomView;
    
return hud;
};

VLBProgressHUDBlock const VLB_PROGRESS_HUD_CUSTOM_VIEW_LOCATION_ERROR_TARGET = ^(MBProgressHUD *hud)
{
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"target.png"]];
    hud.mode = MBProgressHUDModeCustomView;
    
return hud;
};

VLBProgressHUDBlock const VLB_PROGRESS_HUD_CUSTOM_VIEW_CAMERA = ^(MBProgressHUD *hud)
{
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"camera-mini.png"]];
    hud.mode = MBProgressHUDModeCustomView;
    
    return hud;
};

VLBProgressHUDBlock const VLB_PROGRESS_HUD_CUSTOM_VIEW_LOCATION_ARROW = ^(MBProgressHUD *hud)
{
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"location-arrow.png"]];
    [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationCurveLinear | UIViewAnimationOptionAutoreverse | UIViewAnimationOptionRepeat animations:^{
        hud.customView.alpha = 0.5;
    } completion:^(BOOL finished) {

    }];
     
    hud.mode = MBProgressHUDModeCustomView;
    
    return hud;
};

+(MBProgressHUD*)newWithView:(UIView*)view config:(VLBProgressHUDBlock)block
{
	MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:view];
	[view addSubview:hud];

return block(hud);
}

+(MBProgressHUD*)newWithView:(UIView*)view 
{
	MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:view];
	[view addSubview:hud];

return hud;
}

+(MBProgressHUD*)newWithViewLocationArrow:(UIView*)view
{
    MBProgressHUD *hud = [self newWithView:view config:VLB_PROGRESS_HUD_CUSTOM_VIEW_LOCATION_ARROW];
    hud.labelText = @"Finding your location";
	[view addSubview:hud];
    
return hud;
}

+(MBProgressHUD*)newWithViewCamera:(UIView*)view locality:(NSString*)locality
{
    MBProgressHUD *hud = [VLBHuds newWithView:view config:VLB_PROGRESS_HUD_CUSTOM_VIEW_CAMERA];
    hud.labelText = [NSString stringWithFormat:@"No stores in %@", locality];
    hud.detailsLabelText = @"Take a photo of an item in store under your profile. It will appear here.";
    
return hud;
}
@end
