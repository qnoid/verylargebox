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

typedef NS_ENUM(NSInteger, TBButtonIndex)
{
    BUTTON_INDEX_OK = 0,
    BUTTON_INDEX_CANCEL = 1
};

NS_INLINE
NSPredicate* isButtonIndexOk(){
return [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
    NSNumber *buttonIndex = evaluatedObject;
    return buttonIndex.intValue == BUTTON_INDEX_OK;
}];
}

@interface TBAlertViewDelegate ()
@property (nonatomic, strong) NSPredicate *predicateOnButtonIndex;
@property (nonatomic, copy) TBAlertViewBlock alertViewBlock;
-(id)init:(NSPredicate*) predicateOnButtonIndex alertViewBlock:(TBAlertViewBlock)alertViewBlock;
@end

@implementation TBAlertViewDelegate

-(id)init:(NSPredicate*)predicateOnButtonIndex alertViewBlock:(TBAlertViewBlock)alertViewBlock
{
    initOrReturnNil();
    
    self.predicateOnButtonIndex = predicateOnButtonIndex;
    self.alertViewBlock = alertViewBlock;
    
return self;
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if([self.predicateOnButtonIndex evaluateWithObject:TBInteger(buttonIndex)]){
        self.alertViewBlock(alertView);
    }  
}

@end


@implementation TBAlertViews


+(TBAlertViewDelegate*)newAlertViewDelegateOnOk:(TBAlertViewBlock)alertViewBlock{
return [[TBAlertViewDelegate alloc] init:isButtonIndexOk() alertViewBlock:alertViewBlock];
}

+(TBAlertViewDelegate*)newAlertViewDelegateOnOkDismiss
{
    __block TBAlertViewDelegate *alertViewDelegate;
    alertViewDelegate = [self newAlertViewDelegateOnOk:^(UIAlertView* alertView){
        alertViewDelegate = nil;
    }];

return alertViewDelegate;
}

+ (UIAlertView *)newAlertViewWithOk:(NSString *)title message:(NSString *)message {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
        
return alertView;
}
@end
