//
//  VLBSignOutViewController.h
//  verylargebox
//
//  Created by Markos Charatzas on 24/07/2013.
//  Copyright (c) 2013 verylargebox.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class VLBButton;
@class VLBTheBox;

@interface VLBUserSettingsViewController : UIViewController

@property (nonatomic, weak) IBOutlet VLBButton *emailButton;
@property (nonatomic, weak) IBOutlet VLBButton *signOutButton;
@property (nonatomic, weak) IBOutlet UIView *noticeView;

+(VLBUserSettingsViewController*)newUserSettingsViewController:(VLBTheBox*)thebox;

@end
