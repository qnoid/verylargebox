//
//  VLBEmailTextField.m
//  verylargebox
//
//  Created by Markos Charatzas on 22/07/2013.
//  Copyright (c) 2013 verylargebox.com. All rights reserved.
//

#import "VLBEmailTextField.h"
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


@implementation VLBEmailTextField

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    VLB_IF_NOT_SELF_RETURN_NIL();

    self.delegate = self;
    
return self;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    NSPredicate *emailValidation = [NSPredicate predicateWithFormat:@"self MATCHES[c] %@", VLB_EMAIL_VALIDATION_REGEX];
    
    if(![emailValidation evaluateWithObject:textField.text]) {
        return NO;
    }
        
    [self.emailTextFieldDelegate textFieldShouldReturn:textField];
    
return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSPredicate *emailValidation = [NSPredicate predicateWithFormat:@"self MATCHES[c] %@", VLB_EMAIL_VALIDATION_REGEX];
    
    NSString *resolvedEmail = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    BOOL isValidEmail = [emailValidation evaluateWithObject:resolvedEmail];
    
    [self.emailTextFieldDelegate textField:self email:resolvedEmail isValidEmail:isValidEmail];
    
return YES;
}

-(BOOL)textFieldShouldClear:(UITextField *)textField
{    
    textField.textColor = [UIColor lightGrayColor];
    textField.backgroundColor = [UIColor whiteColor];
    
return YES;
}

@end
