//
// Copyright 2013 TheBox
// All rights reserved.
//
// This file is part of thebox
//
// Created by Markos Charatzas on 25/05/2013.
//
//

#import <Foundation/Foundation.h>

typedef void(^VLBAlertViewBlock)(UIAlertView* alertView, NSInteger buttonIndex);

typedef NS_ENUM(NSInteger, VLBButtonIndex)
{
    BUTTON_INDEX_OK = 0,
    BUTTON_INDEX_CANCEL = 1
};

@interface VLBAlertViewDelegate : NSObject <UIAlertViewDelegate>

@end

/**
 Provides access to alertviews and alert view delegates.
 
 */
@interface VLBAlertViews : NSObject

+(VLBAlertViewDelegate *)newAlertViewDelegateOnButtonIndex:(VLBButtonIndex)buttonIndex alertViewBlock:(VLBAlertViewBlock)alertViewBlock;

+(VLBAlertViewDelegate *)newAlertViewDelegateDismissOn:(VLBButtonIndex)buttonIndex;

/**
 @return a new VLBAlertViewDelegate instance that is retained until its alert view is dismissed.
 */
+(VLBAlertViewDelegate *)newAlertViewDelegateOnOkDismiss;

+(VLBAlertViewDelegate *)newAlertViewDelegateOnCancelDismiss;

/**
 
 */
+(VLBAlertViewDelegate *)newAlertViewDelegateOnOk:(VLBAlertViewBlock)alertViewBlock;

+(NSObject<UIAlertViewDelegate>*)all:(NSArray*)alertViewDelegates;

/**
 
 */
+ (UIAlertView *)newAlertViewWithOk:(NSString *)title message:(NSString *)message;

+ (UIAlertView *)newAlertViewWithOkAndCancel:(NSString *)title message:(NSString *)message;

@end
