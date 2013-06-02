/*
 *  Copyright 2013 TheBox
 *  All rights reserved.
 *
 *  This file is part of thebox
 *
 *  Created by Markos Charatzas (___twitter___) 30/05/2013.
 *  Contributor(s): .-
 */
#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"

typedef MBProgressHUD*(^TBProgressHUDBlock)(MBProgressHUD *hud);

extern TBProgressHUDBlock const TB_PROGRESS_HUD_CUSTOM_VIEW_CIRCLE_NO;

@interface TBHuds : NSObject

+(MBProgressHUD*)newWithView:(UIView*)view config:(TBProgressHUDBlock)block;

@end
