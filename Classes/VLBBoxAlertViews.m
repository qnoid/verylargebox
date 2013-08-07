//
// 	VLBBoxAlertViews.m
//  verylargebox
//
//  Created by Markos Charatzas on 27/07/2013.
//  Copyright (c) 2013 (verylargebox.com). All rights reserved.
//

#import "VLBBoxAlertViews.h"

@implementation VLBBoxAlertViews

+(UIAlertView*)location:(NSString*)name bar:(VLBAlertViewBlock)alertViewBlock
{
    VLBAlertViewDelegate *alertViewDelegateOnCancelDismiss = [VLBAlertViews newAlertViewDelegateOnCancelDismiss];
    
    NSString *message = [NSString stringWithFormat:NSLocalizedString(@"viewcontrollers.directions.details", @"Get directions directions%@"),
                                                   [@"" isEqual:name] ? NSLocalizedString(@"questionmark", @"?") : [NSString stringWithFormat:NSLocalizedString(@"viewcontrollers.directions.question", @" to %@?"), name]];
    
    UIAlertView *alertView = [VLBAlertViews newAlertViewWithNevermind:NSLocalizedString(@"viewcontrollers.directions.button.ok", @"Open in Maps")
                                                            message:message];

    NSInteger index = [alertView addButtonWithTitle:NSLocalizedString(@"viewcontrollers.directions.header", @"Open in Maps")];
    
    VLBAlertViewDelegate *alertViewDelegateOnOkGetDirections =
        [VLBAlertViews newAlertViewDelegateOnButtonIndex:index alertViewBlock:alertViewBlock];

    alertView.delegate = [VLBAlertViews all:@[alertViewDelegateOnOkGetDirections, alertViewDelegateOnCancelDismiss]];
    
return alertView;
}
@end
