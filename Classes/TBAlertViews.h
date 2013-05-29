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

typedef void(^TBAlertViewBlock)(UIAlertView* alertView, NSInteger buttonIndex);

typedef NS_ENUM(NSInteger, TBButtonIndex)
{
    BUTTON_INDEX_OK = 0,
    BUTTON_INDEX_CANCEL = 1
};

@interface TBAlertViewDelegate : NSObject <UIAlertViewDelegate>

@end

/**
 Provides access to alertviews and alert view delegates.
 
 */
@interface TBAlertViews : NSObject

+(TBAlertViewDelegate*)newAlertViewDelegateOnButtonIndex:(TBButtonIndex)buttonIndex alertViewBlock:(TBAlertViewBlock)alertViewBlock;

+(TBAlertViewDelegate*)newAlertViewDelegateDismissOn:(TBButtonIndex)buttonIndex;

/**
 @return a new TBAlertViewDelegate instance that is retained until its alert view is dismissed.
 */
+(TBAlertViewDelegate*)newAlertViewDelegateOnOkDismiss;

+(TBAlertViewDelegate*)newAlertViewDelegateOnCancelDismiss;

/**
 
 */
+(TBAlertViewDelegate*)newAlertViewDelegateOnOk:(TBAlertViewBlock)alertViewBlock;

+(NSObject<UIAlertViewDelegate>*)all:(NSArray*)alertViewDelegates;

/**
 
 */
+ (UIAlertView *)newAlertViewWithOk:(NSString *)title message:(NSString *)message;

+ (UIAlertView *)newAlertViewWithOkAndCancel:(NSString *)title message:(NSString *)message;

@end
