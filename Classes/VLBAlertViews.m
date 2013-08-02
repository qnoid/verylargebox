//
// 	VLBAlertViews.m
//  verylargebox
//
//  Created by Markos Charatzas on 25/05/2013.
//  Copyright (c) 2013 (verylargebox.com). All rights reserved.
//

#import "VLBAlertViews.h"
#import "VLBMacros.h"

NS_INLINE
NSPredicate* isButtonIndex(VLBButtonIndex buttonIndex){
    return [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        return ((NSNumber*)evaluatedObject).intValue == buttonIndex;
    }];
}

NS_INLINE
NSPredicate* isButtonIndexOk(){
    return isButtonIndex(BUTTON_INDEX_OK);
}

NS_INLINE
NSPredicate* isButtonIndexCancel(){
    return isButtonIndex(BUTTON_INDEX_CANCEL);
}

@interface VLBAlertViewDelegate ()
@property (nonatomic, strong) NSPredicate *predicateOnButtonIndex;
@property (nonatomic, copy) VLBAlertViewBlock alertViewBlock;
-(id)init:(NSPredicate*) predicateOnButtonIndex alertViewBlock:(VLBAlertViewBlock)alertViewBlock;
@end

@implementation VLBAlertViewDelegate

-(id)init:(NSPredicate*)predicateOnButtonIndex alertViewBlock:(VLBAlertViewBlock)alertViewBlock
{
    VLB_INIT_OR_RETURN_NIL();
    
    self.predicateOnButtonIndex = predicateOnButtonIndex;
    self.alertViewBlock = alertViewBlock;
    
    return self;
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(![self.predicateOnButtonIndex evaluateWithObject:VLB_Integer(buttonIndex)]){
        return;
    }

    self.alertViewBlock(alertView, buttonIndex);
}

@end


@implementation VLBAlertViews

+(VLBAlertViewDelegate *)newAlertViewDelegateOnPredicate:(NSPredicate*)predicate alertViewBlock:(VLBAlertViewBlock)alertViewBlock{
    return [[VLBAlertViewDelegate alloc] init:predicate alertViewBlock:alertViewBlock];
}

+(VLBAlertViewDelegate *)newAlertViewDelegateOnButtonIndex:(VLBButtonIndex)buttonIndex alertViewBlock:(VLBAlertViewBlock)alertViewBlock{
    return [[VLBAlertViewDelegate alloc] init:isButtonIndex(buttonIndex) alertViewBlock:alertViewBlock];
}

+(VLBAlertViewDelegate *)newAlertViewDelegateOnOk:(VLBAlertViewBlock)alertViewBlock{
    return [[VLBAlertViewDelegate alloc] init:isButtonIndexOk() alertViewBlock:alertViewBlock];
}

+(VLBAlertViewDelegate *)newAlertViewDelegateOnCancel:(VLBAlertViewBlock)alertViewBlock{
    return [[VLBAlertViewDelegate alloc] init:isButtonIndexCancel() alertViewBlock:alertViewBlock];
}

+(VLBAlertViewDelegate *)newAlertViewDelegateDismissOn:(VLBButtonIndex)buttonIndex
{
    __block VLBAlertViewDelegate *alertViewDelegate;
    alertViewDelegate = [self newAlertViewDelegateOnButtonIndex:buttonIndex alertViewBlock:^(UIAlertView* alertView, NSInteger buttonIndex){
        alertViewDelegate = nil;
    }];
    
    return alertViewDelegate;
}

+(VLBAlertViewDelegate *)newAlertViewDelegateOnOkDismiss {
    return [self newAlertViewDelegateDismissOn:BUTTON_INDEX_OK];
}

+(VLBAlertViewDelegate *)newAlertViewDelegateOnCancelDismiss {
    return [self newAlertViewDelegateDismissOn:BUTTON_INDEX_CANCEL];
}

+(NSObject<UIAlertViewDelegate>*)all:(NSArray*)alertViewDelegates
{
    __block NSObject<UIAlertViewDelegate>* all = [self newAlertViewDelegateOnPredicate:[NSPredicate predicateWithValue:YES] alertViewBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
        for (NSObject<UIAlertViewDelegate> *alertViewDelegate in alertViewDelegates) {
            [alertViewDelegate alertView:alertView clickedButtonAtIndex:buttonIndex];
        }
        all = nil;
    }];
    
    return all;
}

+ (UIAlertView *)newAlertViewWithOk:(NSString *)title message:(NSString *)message {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:@"Dismiss"
                                              otherButtonTitles:nil];
    
    return alertView;
}

+ (UIAlertView *)newAlertViewWithOkAndCancel:(NSString *)title message:(NSString *)message {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:@"Cancel"
                                              otherButtonTitles:@"Ok", nil];
    
    return alertView;
}

+ (UIAlertView *)newAlertViewWithNevermind:(NSString *)title message:(NSString *)message
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:@"Nevermind"
                                              otherButtonTitles:nil];
        
    return alertView;
}


@end
