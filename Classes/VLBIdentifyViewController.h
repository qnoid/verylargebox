//
//  VLBIdentifyViewController.h
//  verylargebox
//
//  Created by Markos Charatzas on 21/07/2013.
//  Copyright (c) 2013 verylargebox.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VLBEmailTextField.h"
#import "VLBCreateUserOperationDelegate.h"
#import "VLBVerifyUserOperationDelegate.h"

@class VLBButton;
@class VLBTheBox;

@interface VLBIdentifyViewController : UIViewController <VLBEmailTextFieldDelegate, VLBCreateUserOperationDelegate, VLBVerifyUserOperationDelegate>

@property (nonatomic, weak) IBOutlet VLBButton *signInButton;
@property (nonatomic, weak) IBOutlet VLBButton *signUpButton;
@property (nonatomic, weak) IBOutlet VLBButton *emailButton;
@property (nonatomic, weak) IBOutlet VLBEmailTextField *emailTextField;
@property (nonatomic, weak) IBOutlet UIView *noticeView;

+(VLBIdentifyViewController*)newIdentifyViewController:(VLBTheBox*)thebox;

@end
