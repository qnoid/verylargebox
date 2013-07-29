//
//  VLBEmailTextField.h
//  verylargebox
//
//  Created by Markos Charatzas on 22/07/2013.
//  Copyright (c) 2013 verylargebox.com. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^VLBTextFieldWillReturn)(UITextField *textField);
typedef void(^VLBTextFieldDidEnterEmail)(UITextField *textField, NSString* email, BOOL isValid);

@interface VLBEmailTextFieldDelegate : NSObject <UITextFieldDelegate>

@property(nonatomic, copy) VLBTextFieldWillReturn onReturn;
@property(nonatomic, copy) VLBTextFieldDidEnterEmail didEnterEmail;
@end
