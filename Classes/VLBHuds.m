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

+(MBProgressHUD*)newWithView:(UIView*)view config:(VLBProgressHUDBlock)block
{
	MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:view];
	[view addSubview:hud];

return block(hud);
}
@end
