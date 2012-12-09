//
//  TBEmailViewController.h
//  thebox
//
//  Created by Markos Charatzas on 19/11/2012.
//  Copyright (c) 2012 TheBox. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TBCreateUserOperationDelegate.h"

@class TBButton;

/**
  Asks the user for her email and makes a new registration with server.
 
 */
@interface TBEmailViewController : UIViewController <UITextFieldDelegate>

@property (nonatomic, weak) IBOutlet TBButton *theBoxButton;
@property (nonatomic, weak) IBOutlet UITextField *emailTextField;
@property (nonatomic, weak) IBOutlet TBButton *registerButton;
@property (nonatomic, weak) id<TBCreateUserOperationDelegate> createUserOperationDelegate;

+(TBEmailViewController*)newEmailViewController;

@end
