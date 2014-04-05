//
//  VLBIdentifyViewController.h
//  verylargebox
//
//  Created by Markos Charatzas on 21/07/2013.
//  Copyright (c) 2013 verylargebox.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VLBEmailTextFieldDelegate.h"
#import "VLBCreateUserOperationDelegate.h"
#import "VLBVerifyUserOperationDelegate.h"

@class VLBButton;
@class VLBTheBox;

@interface VLBIdentifyViewController : UIViewController <VLBCreateUserOperationDelegate, VLBVerifyUserOperationDelegate>

@property (nonatomic, weak) IBOutlet VLBButton *signInButton;
@property (nonatomic, weak) IBOutlet VLBButton *signUpButton;
@property (nonatomic, weak) IBOutlet VLBButton *emailButton;
@property (nonatomic, weak) IBOutlet UITextField *emailTextField;
@property (nonatomic, weak) IBOutlet UIView *noticeView;
@property (nonatomic, weak) IBOutlet UIButton *termsOfServiceButton;

+(VLBIdentifyViewController*)newIdentifyViewController:(VLBTheBox*)thebox;

@end
