//
//  TBIdentifyViewController.h
//  thebox
//
//  Created by Markos Charatzas on 18/11/2012.
//  Copyright (c) 2012 TheBox. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "TBButton.h"
#import "TBVerifyUserOperationDelegate.h"

@interface TBIdentifyViewController : UIViewController <TBVerifyUserOperationDelegate>

@property (nonatomic, unsafe_unretained) IBOutlet TBButton *theBoxButton;
@property (nonatomic, unsafe_unretained) IBOutlet TBButton *identifyButton;
@property (nonatomic, unsafe_unretained) IBOutlet TBButton *emailButton;
@property (nonatomic, unsafe_unretained) IBOutlet TBButton *browseButton;

+(TBIdentifyViewController*)newIdentifyViewController;

@end
