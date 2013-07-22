//
//  VLBIdentifyViewController.h
//  verylargebox
//
//  Created by Markos Charatzas on 18/11/2012.
//  Copyright (c) 2012 (verylargebox.com). All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "VLBButton.h"
#import "VLBVerifyUserOperationDelegate.h"
#import "VLBCreateUserOperationDelegate.h"
#import "VLBView.h"
#import "VLBAFHTTPRequestOperationCompletionBlocks.h"

@protocol VLBButton;
@class QNDAnimatedView;
@class VLBTheBox;


/**
 
 
 Holds, in memory, an index of email statuses for each email account registered with thebox.
 */
@interface VLBEmailViewController : UIViewController <VLBVerifyUserOperationDelegate, VLBCreateUserOperationDelegate, UITableViewDelegate, VLBViewDrawRectDelegate>

@property (nonatomic, weak) IBOutlet VLBButton *identifyButton;
@property (nonatomic, weak) IBOutlet UITextField *emailTextField;
@property (nonatomic, weak) IBOutlet UITableView *accountsTableView;

+(VLBEmailViewController*)newEmailViewController:(VLBTheBox*)thebox;
@end
