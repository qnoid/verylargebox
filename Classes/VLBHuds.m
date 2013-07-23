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

void vlb_animate(UIView *view)
{
    [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationCurveLinear | UIViewAnimationOptionAutoreverse | UIViewAnimationOptionRepeat animations:^{
        view.alpha = 0.5;
    } completion:^(BOOL finished) {
        
    }];
}

VLBProgressHUDBlock const VLB_PROGRESS_HUD_CUSTOM_VIEW_IDCARD = ^(MBProgressHUD *hud)
{
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"idcard-white.png"]];
    hud.mode = MBProgressHUDModeCustomView;
    
    return hud;
};

VLBProgressHUDBlock const VLB_PROGRESS_HUD_CUSTOM_VIEW_IPHONE = ^(MBProgressHUD *hud)
{
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"iphone.png"]];
    hud.mode = MBProgressHUDModeCustomView;
    
    return hud;
};

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

VLBProgressHUDBlock const VLB_PROGRESS_HUD_CUSTOM_VIEW_ENVELOPE = ^(MBProgressHUD *hud)
{
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"envelope.png"]];
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

+(MBProgressHUD*)newOnDidFailOnVerifyWithError:(UIView*)view
{
    MBProgressHUD* hud = [VLBHuds newWithView:view config:VLB_PROGRESS_HUD_CUSTOM_VIEW_CIRCLE_NO];
    
    hud.labelText = @"Unauthorised device";
    hud.detailsLabelText = [NSString stringWithFormat:@"%@ is not authorised. Please check your email to verify it.",
                            [[UIDevice currentDevice] name]];
    
return hud;
}

+(MBProgressHUD*)newViewWithIdCard:(UIView*)view
{
    MBProgressHUD* hud = [VLBHuds newWithView:view config:VLB_PROGRESS_HUD_CUSTOM_VIEW_IDCARD];
    
    hud.labelText = @"Add your photos in the box.";
    hud.detailsLabelText = [NSString stringWithFormat:@"What happens next? \n \n You will receive an email to give %@ access to verylargebox. \n \n Your email is only used to verify your identity. \n \n",
                            [[UIDevice currentDevice] name]];
    

return hud;
}

+(MBProgressHUD*)newOnDidSucceedWithRegistration:(UIView*)view email:(NSString *)email residence:(NSString *)residence
{
    MBProgressHUD* hud = [VLBHuds newWithView:view config:VLB_PROGRESS_HUD_CUSTOM_VIEW_ENVELOPE];
	  hud.labelText = @"Please check your email.";
    hud.detailsLabelText = [NSString stringWithFormat:@"If you cannot find it, check your spam. \n \n Double check you have entered your email correct, '%@'. \n Tap to edit if it's wrong. \n \n Once you have verified, return here to sign in.", email];
        
return hud;
}

+(MBProgressHUD*)newOnDidEnterEmail:(UIView*)view email:(NSString *)email
{
    MBProgressHUD* hud = [VLBHuds newWithView:view config:^MBProgressHUD *(MBProgressHUD *hud) {
        VLB_PROGRESS_HUD_CUSTOM_VIEW_ENVELOPE(hud);
        vlb_animate(hud.customView);
    return hud;
    }];
    
    hud.labelText = @"An email is on your way.";

return hud;
}

+(MBProgressHUD*)newOnDidSignIn:(UIView*)view email:(NSString*)email
{
    MBProgressHUD* hud = [VLBHuds newWithView:view config:^MBProgressHUD *(MBProgressHUD *hud) {
        VLB_PROGRESS_HUD_CUSTOM_VIEW_IDCARD(hud);
        vlb_animate(hud.customView);
    return hud;
    }];
    
    hud.labelText = @"Signing you in.";
    hud.detailsLabelText = [NSString stringWithFormat:@"Please wait while verylargebox is signing you in as %@", email];
    
return hud;
}

@end
