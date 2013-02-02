//
//  TBProfileViewController.h
//  thebox
//
//  Created by Markos Charatzas on 18/11/2012.
//  Copyright (c) 2012 TheBox. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TBCreateItemOperationDelegate.h"

@interface TBProfileViewController : UIViewController <TBCreateItemOperationDelegate>

+(TBProfileViewController*)newProfileViewController;

@end
