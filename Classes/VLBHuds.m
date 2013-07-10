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

NS_INLINE
void vlb_animate(UIView *view)
{
    [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationCurveLinear | UIViewAnimationOptionAutoreverse | UIViewAnimationOptionRepeat animations:^{
        view.alpha = 0.5;
    } completion:^(BOOL finished) {
        
    }];
}

VLBProgressHUDBlock const VLB_PROGRESS_HUD_CUSTOM_VIEW_CIRCLE_NO = ^(MBProgressHUD *hud)
{
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"circle-no.png"]];
    hud.mode = MBProgressHUDModeCustomView;
    
return hud;
};

VLBProgressHUDBlock const VLB_PROGRESS_HUD_CUSTOM_VIEW_RADAR = ^(MBProgressHUD *hud)
{
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"radar.png"]];
    vlb_animate(hud.customView);
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
    vlb_animate(hud.customView);
    hud.mode = MBProgressHUDModeCustomView;
    
return hud;
};

VLBProgressHUDBlock const VLB_PROGRESS_HUD_CUSTOM_VIEW_SEARCH = ^(MBProgressHUD *hud)
{
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"search.png"]];
    vlb_animate(hud.customView);    
    hud.mode = MBProgressHUDModeCustomView;
    
return hud;
};


+(MBProgressHUD*)newWithView:(UIView*)view config:(VLBProgressHUDBlock)block
{
	MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:view];
    hud.userInteractionEnabled = NO;    
	[view addSubview:hud];

return block(hud);
}

+(MBProgressHUD*)newWithView:(UIView*)view
{
	MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:view];
    hud.userInteractionEnabled = NO;
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

+(MBProgressHUD*)newWithViewRadar:(UIView*)view
{
    MBProgressHUD *hud = [self newWithView:view config:VLB_PROGRESS_HUD_CUSTOM_VIEW_RADAR];
    hud.labelText = @"Finding stores nearby";
	[view addSubview:hud];
    
return hud;
}

+(MBProgressHUD*)newWithViewSearch:(UIView*)view query:(NSString*)query
{
    MBProgressHUD *hud = [self newWithView:view config:VLB_PROGRESS_HUD_CUSTOM_VIEW_SEARCH];
    hud.labelText = @"Finding stores nearby";
    hud.detailsLabelText = [NSString stringWithFormat:@"matching '%@'", query];
	[view addSubview:hud];
    
return hud;
}
@end
