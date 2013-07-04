//
//  VLBErrorBlocks.m
//  verylargebox
//
//  Created by Markos Charatzas on 02/06/2013.
//  Copyright (c) 2013 (verylargebox.com). All rights reserved.
//

#import "VLBErrorBlocks.h"
#import "MBProgressHUD.h"
#import "VLBHuds.h"

@implementation VLBErrorBlocks

+(VLBAFHTTPRequestOperationErrorBlock) localizedDescriptionOfErrorBlock:(UIView*) view
{
    return ^BOOL(NSError* error)
    {
        MBProgressHUD *hud = [VLBHuds newWithView:view config:VLB_PROGRESS_HUD_CUSTOM_VIEW_CIRCLE_NO];
        hud.detailsLabelText = error.localizedDescription;
        [hud show:YES];
        [hud hide:YES afterDelay:5.0];
    return YES;
    };
}

@end
