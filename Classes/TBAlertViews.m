/*
 *  Copyright 2010 The Box
 *  All rights reserved.
 *
 *  This file is part of TheBox
 *
 *  Created by Markos Charatzas (@qnoid) on 25/05/2013.
 *  Contributor(s): .-
 */
#import "TBAlertViews.h"
#import "TBMacros.h"
#import <objc/runtime.h>

NS_INLINE
NSPredicate* isButtonIndex(TBButtonIndex buttonIndex){
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

@interface TBAlertViewDelegate ()
@property (nonatomic, strong) NSPredicate *predicateOnButtonIndex;
@property (nonatomic, copy) TBAlertViewBlock alertViewBlock;
-(id)init:(NSPredicate*) predicateOnButtonIndex alertViewBlock:(TBAlertViewBlock)alertViewBlock;
@end

@implementation TBAlertViewDelegate

-(id)init:(NSPredicate*)predicateOnButtonIndex alertViewBlock:(TBAlertViewBlock)alertViewBlock
{
    TB_INIT_OR_RETURN_NIL();
    
    self.predicateOnButtonIndex = predicateOnButtonIndex;
    self.alertViewBlock = alertViewBlock;
    
return self;
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if([self.predicateOnButtonIndex evaluateWithObject:TBInteger(buttonIndex)]){
        self.alertViewBlock(alertView, buttonIndex);
    }  
}

@end


@implementation TBAlertViews

+(TBAlertViewDelegate*)newAlertViewDelegateOnPredicate:(NSPredicate*)predicate alertViewBlock:(TBAlertViewBlock)alertViewBlock{
return [[TBAlertViewDelegate alloc] init:predicate alertViewBlock:alertViewBlock];
}

+(TBAlertViewDelegate*)newAlertViewDelegateOnButtonIndex:(TBButtonIndex)buttonIndex alertViewBlock:(TBAlertViewBlock)alertViewBlock{
return [[TBAlertViewDelegate alloc] init:isButtonIndex(buttonIndex) alertViewBlock:alertViewBlock];
}

+(TBAlertViewDelegate*)newAlertViewDelegateOnOk:(TBAlertViewBlock)alertViewBlock{
return [[TBAlertViewDelegate alloc] init:isButtonIndexOk() alertViewBlock:alertViewBlock];
}

+(TBAlertViewDelegate*)newAlertViewDelegateOnCancel:(TBAlertViewBlock)alertViewBlock{
return [[TBAlertViewDelegate alloc] init:isButtonIndexCancel() alertViewBlock:alertViewBlock];
}

+(TBAlertViewDelegate*)newAlertViewDelegateDismissOn:(TBButtonIndex)buttonIndex
{
    __block TBAlertViewDelegate *alertViewDelegate;
    alertViewDelegate = [self newAlertViewDelegateOnButtonIndex:buttonIndex alertViewBlock:^(UIAlertView* alertView, NSInteger buttonIndex){
        alertViewDelegate = nil;
    }];
    
    return alertViewDelegate;
}

+(TBAlertViewDelegate*)newAlertViewDelegateOnOkDismiss {
return [self newAlertViewDelegateDismissOn:BUTTON_INDEX_OK];
}

+(TBAlertViewDelegate*)newAlertViewDelegateOnCancelDismiss {
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
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
        
return alertView;
}

+ (UIAlertView *)newAlertViewWithOkAndCancel:(NSString *)title message:(NSString *)message {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:@"Cancel", nil];
    
    return alertView;
}

@end
