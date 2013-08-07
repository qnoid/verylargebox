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
    hud.labelText = NSLocalizedString(@"huds.locationarrow.header", @"Finding your location");
	[view addSubview:hud];
    
return hud;
}

+(MBProgressHUD*)newWithViewCamera:(UIView*)view locality:(NSString*)locality
{
    MBProgressHUD *hud = [VLBHuds newWithView:view config:VLB_PROGRESS_HUD_CUSTOM_VIEW_CAMERA];
    hud.labelText = NSLocalizedString(@"huds.camera.header", @"No stores found");
    hud.detailsLabelText = NSLocalizedString(@"huds.camera.details", @"Take a photo of an item in store under your profile. It will appear here.");
    
return hud;
}

+(MBProgressHUD*)newWithViewRadar:(UIView*)view
{
    MBProgressHUD *hud = [self newWithView:view config:VLB_PROGRESS_HUD_CUSTOM_VIEW_RADAR];
    hud.labelText = NSLocalizedString(@"huds.radar.header", @"Finding stores nearby");
	[view addSubview:hud];
    
return hud;
}

+(MBProgressHUD*)newWithViewSearch:(UIView*)view query:(NSString*)query
{
    MBProgressHUD *hud = [self newWithView:view config:VLB_PROGRESS_HUD_CUSTOM_VIEW_SEARCH];
    hud.labelText = NSLocalizedString(@"huds.search.header", @"Finding stores nearby");
    hud.detailsLabelText = [NSString stringWithFormat:NSLocalizedString(@"huds.search.details", @"matching '%@'"), query];
	[view addSubview:hud];
    
return hud;
}

+(MBProgressHUD*)newOnDidFailOnVerifyWithError:(UIView*)view
{
    MBProgressHUD* hud = [VLBHuds newWithView:view config:VLB_PROGRESS_HUD_CUSTOM_VIEW_CIRCLE_NO];
    
    hud.labelText = NSLocalizedString(@"huds.verify.failed.header", @"Unauthorised device");
    hud.detailsLabelText = [NSString stringWithFormat:NSLocalizedString(@"huds.verify.failed.details", @"%@ is not authorised. Please check your email to verify it."),
                                                      [[UIDevice currentDevice] name]];
    
return hud;
}

+(MBProgressHUD*)newViewWithIdCard:(UIView*)view
{
    MBProgressHUD* hud = [VLBHuds newWithView:view config:VLB_PROGRESS_HUD_CUSTOM_VIEW_IDCARD];
    
    hud.labelText = NSLocalizedString(@"huds.idcard.header", @"Add your photos.");
    hud.detailsLabelText = [NSString stringWithFormat:NSLocalizedString(@"huds.idcard.details", @"What happens next? \n \n You will receive an email to give %@ access to verylargebox. \n \n Your email is only used to verify your identity. \n \n"),
                                                      [[UIDevice currentDevice] name]];
    

return hud;
}

+(MBProgressHUD*)newOnDidSucceedWithRegistration:(UIView*)view email:(NSString *)email residence:(NSString *)residence
{
    MBProgressHUD* hud = [VLBHuds newWithView:view config:VLB_PROGRESS_HUD_CUSTOM_VIEW_ENVELOPE];
	  hud.labelText = NSLocalizedString(@"huds.registration.header", @"Please check your email.");
    hud.detailsLabelText = [NSString stringWithFormat:NSLocalizedString(@"huds.registration.details", @"If you cannot find it, check your spam. \n \n Double check you have entered your email correctly, '%@'. \n Tap to edit if it's wrong. \n \n Once you have verified, return here to sign in."), email];
        
return hud;
}

+(MBProgressHUD*)newOnDidEnterEmail:(UIView*)view email:(NSString *)email
{
    MBProgressHUD* hud = [VLBHuds newWithView:view config:^MBProgressHUD *(MBProgressHUD *hud) {
        VLB_PROGRESS_HUD_CUSTOM_VIEW_ENVELOPE(hud);
        vlb_animate(hud.customView);
    return hud;
    }];
    
    hud.labelText = NSLocalizedString(@"huds.email.header", @"An email it is on its way.");

return hud;
}

+(MBProgressHUD*)newOnDidSignIn:(UIView*)view email:(NSString*)email
{
    MBProgressHUD* hud = [VLBHuds newWithView:view config:^MBProgressHUD *(MBProgressHUD *hud) {
        VLB_PROGRESS_HUD_CUSTOM_VIEW_IDCARD(hud);
        vlb_animate(hud.customView);
    return hud;
    }];
    
    hud.labelText = NSLocalizedString(@"huds.signin.header", @"Signing you in.");
    hud.detailsLabelText = [NSString stringWithFormat:NSLocalizedString(@"huds.signin.details", @"Please wait while verylargebox is signing you in as %@"), email];
    
return hud;
}

+(MBProgressHUD*)newSignOutViewWithIdCard:(UIView*)view
{
    MBProgressHUD* hud = [VLBHuds newWithView:view config:VLB_PROGRESS_HUD_CUSTOM_VIEW_IDCARD];
    
    hud.labelText = NSLocalizedString(@"huds.signout.header", @"Sign out.");
    hud.detailsLabelText = [NSString stringWithFormat:NSLocalizedString(@"huds.signout.details", @"What happens next? \n \n You will need to verify your email again to add photos to verylargebox. \n \n Your existing photos will not be affected. \n \n Other features will remain accessible.")];
    
    return hud;
}

+(MBProgressHUD*)newNoStoresFound:(UIView*)view
{
    MBProgressHUD* hud = [VLBHuds newWithView:view config:VLB_PROGRESS_HUD_CUSTOM_VIEW_CIRCLE_NO];

    hud.labelText = @"No stores found";
    hud.detailsLabelText = @"There were no stores found";

    return hud;
}

@end
