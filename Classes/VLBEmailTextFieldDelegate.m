//
//  VLBEmailTextField.m
//  verylargebox
//
//  Created by Markos Charatzas on 22/07/2013.
//  Copyright (c) 2013 verylargebox.com. All rights reserved.
//

#import "VLBEmailTextFieldDelegate.h"
#import "VLBColors.h"
#import "VLBMacros.h"

NSString* const VLB_EMAIL_VALIDATION_REGEX =
@"(?:[a-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[a-z0-9!#$%\\&'*+/=?\\^_`{|}"
@"~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\"
@"x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-"
@"z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5"
@"]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-"
@"9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21"
@"-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])";

VLBTextFieldWillReturn const VLBTextFieldWillReturnEmpty = ^(UITextField* textfield){};
VLBTextFieldDidEnterEmail const VLBTextFieldDidEnterEmailEmpty = ^(UITextField *textField, NSString* email, BOOL isValid){};

@implementation VLBEmailTextFieldDelegate

- (id)init
{
    VLB_INIT_OR_RETURN_NIL();
    
    self.onReturn = VLBTextFieldWillReturnEmpty;
    self.didEnterEmail = VLBTextFieldDidEnterEmailEmpty;
    
return self;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    NSPredicate *emailValidation = [NSPredicate predicateWithFormat:@"self MATCHES[c] %@", VLB_EMAIL_VALIDATION_REGEX];
    
    if(![emailValidation evaluateWithObject:textField.text]) {
        return NO;
    }
        
    self.onReturn(textField);
    
return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSPredicate *emailValidation = [NSPredicate predicateWithFormat:@"self MATCHES[c] %@", VLB_EMAIL_VALIDATION_REGEX];
    
    NSString *resolvedEmail = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    BOOL isValidEmail = [emailValidation evaluateWithObject:resolvedEmail];
    
    self.didEnterEmail(textField, resolvedEmail, isValidEmail);
    
return YES;
}

@end
