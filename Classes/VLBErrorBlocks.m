//
//  VLBErrorBlocks.m
//  verylargebox
//
//  Created by Markos Charatzas on 02/06/2013.
//  Copyright (c) 2013 (verylargebox.com). All rights reserved.
//

#import "VLBErrorBlocks.h"
#import <CoreLocation/CoreLocation.h>
#import "MBProgressHUD.h"
#import "VLBHuds.h"
#import "VLBAlertViews.h"

@implementation VLBErrorBlocks

+(VLBAFHTTPRequestOperationErrorBlock) locationErrorBlock:(UIView*) view config:(VLBProgressHUDBlock)block
{
    return ^BOOL(NSError* error)
    {
    switch (error.code) {
			case kCLErrorLocationUnknown:
            case kCLErrorNetwork:
            case kCLErrorGeocodeFoundNoResult:
            {
                MBProgressHUD *hud = [VLBHuds newWithView:view config:block];
                hud.detailsLabelText = @"Could not find your location. Usually this happens if you are inside a building, have poor network connection or in a remote area.";                
                [hud show:YES];
                [hud hide:YES afterDelay:5.0];
            }
			break;
            case kCLErrorDenied:
            {
                MBProgressHUD *hud = [VLBHuds newWithView:view config:VLB_PROGRESS_HUD_CUSTOM_VIEW_CIRCLE_NO];
                hud.labelText = @"Location access denied";
                hud.detailsLabelText = @"Go to \n Settings > \n Privacy > \n Location Services > \n Turn switch to 'ON' under 'verylargebox' to access your location.";
                
			    [hud show:YES];
			}
            break;
			default:{
					[VLBErrorBlocks localizedDescriptionOfErrorBlock:view](error);
			}
			break;
    }
    return YES;
    };
}

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
