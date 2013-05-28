/*
 *  Copyright 2013 TheBox
 *  All rights reserved.
 *
 *  This file is part of thebox
 *
 *  Created by Markos Charatzas (___twitter___) 25/05/2013.
 *  Contributor(s): .-
 */
#import <Foundation/Foundation.h>

typedef void(^TBAlertViewBlock)(UIAlertView* alertView);

@interface TBAlertViewDelegate : NSObject <UIAlertViewDelegate>

@end

/**
 Provides access to alertviews and alert view delegates.
 
 */
@interface TBAlertViews : NSObject

/**
 @return a new TBAlertViewDelegate instance that is retained until its alert view is dismissed.
 */
+(TBAlertViewDelegate*)newAlertViewDelegateOnOkDismiss;

/**
 
 */
+(TBAlertViewDelegate*)newAlertViewDelegateOnOk:(TBAlertViewBlock)alertViewBlock;

/**
 
 */
+ (UIAlertView *)newAlertViewWithOk:(NSString *)title message:(NSString *)message;

@end
