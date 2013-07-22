//
//  VLBEmailTextField.h
//  verylargebox
//
//  Created by Markos Charatzas on 22/07/2013.
//  Copyright (c) 2013 verylargebox.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol VLBEmailTextFieldDelegate <UITextFieldDelegate>

- (void)textField:(UITextField *)textField email:(NSString *)email isValidEmail:(BOOL) isValidEmail;

@end

@interface VLBEmailTextField : UITextField <UITextFieldDelegate>

@property(nonatomic, weak) IBOutlet id<VLBEmailTextFieldDelegate> emailTextFieldDelegate;
@end
