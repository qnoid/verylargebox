//
//  TBErrorBlocks.m
//  thebox
//
//  Created by Markos Charatzas on 02/06/2013.
//  Copyright (c) 2013 TheBox. All rights reserved.
//

#import "TBErrorBlocks.h"
#import "MBProgressHUD.h"
#import "TBHuds.h"

@implementation TBErrorBlocks

+(TBAFHTTPRequestOperationErrorBlock) localizedDescriptionOfErrorBlock:(UIView*) view
{
    return ^BOOL(NSError* error)
    {
        MBProgressHUD *hud = [TBHuds newWithView:view config:TB_PROGRESS_HUD_CUSTOM_VIEW_CIRCLE_NO];
        hud.detailsLabelText = error.localizedDescription;
        [hud show:YES];
        [hud hide:YES afterDelay:3.0];
    return YES;
    };
}

@end
