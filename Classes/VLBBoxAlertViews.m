//
// 	VLBBoxAlertViews.m
//  verylargebox
//
//  Created by Markos Charatzas on 27/07/2013.
//  Copyright (c) 2013 (verylargebox.com). All rights reserved.
//

#import "VLBBoxAlertViews.h"
#import "VLBAlertViews.h"

@implementation VLBBoxAlertViews

+(UIAlertView*)location:(NSString*)name bar:(NSObject<UIAlertViewDelegate>*)alertViewDelegateOnOkGetDirections
{
    VLBAlertViewDelegate *alertViewDelegateOnCancelDismiss = [VLBAlertViews newAlertViewDelegateOnCancelDismiss];
    
    NSObject<UIAlertViewDelegate> *didTapOnGetDirectionsDelegate =
    [VLBAlertViews all:@[alertViewDelegateOnOkGetDirections, alertViewDelegateOnCancelDismiss]];
    
    UIAlertView *alertView = [VLBAlertViews newAlertViewWithOkAndCancel:@"Get Directions" message:[NSString stringWithFormat:@"Exit the app and get directions%@", [@"" isEqual:name]? @"." : [NSString stringWithFormat:@" to %@.", name]]];
    
    alertView.delegate = didTapOnGetDirectionsDelegate;
    
return alertView;
}
@end
