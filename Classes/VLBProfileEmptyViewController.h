//
//  VLBProfileEmptyView.h
//  verylargebox
//
//  Created by Markos Charatzas on 05/07/2013.
//  Copyright (c) 2013 verylargebox.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VLBView.h"
#import "VLBCreateItemOperationDelegate.h"
#import "VLBNotificationView.h"

@class VLBButton;
@class VLBTheBox;

@interface VLBProfileEmptyViewController : UIViewController <VLBNotificationViewDelegate>

@property(nonatomic, weak) IBOutlet VLBButton *takePhotoButton;
@property(nonatomic, weak) IBOutlet UILabel *takePhotoLabel;

+(VLBProfileEmptyViewController *)newProfileViewController:(VLBTheBox*)thebox residence:(NSDictionary*)residence email:(NSString*)email;

-(IBAction)didTouchUpInsideTakePhoto;

@end
