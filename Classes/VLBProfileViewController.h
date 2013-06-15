//
//  VLBProfileViewController.h
//  thebox
//
//  Created by Markos Charatzas on 18/11/2012.
//  Copyright (c) 2012 (verylargebox.com). All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VLBScrollView.h"
#import "VLBCreateItemOperationDelegate.h"
#import "VLBItemsOperationDelegate.h"
#import "VLBLocationServiceDelegate.h"

@interface VLBProfileViewController : UIViewController <VLBCreateItemOperationDelegate, VLBScrollViewDatasource, VLBScrollViewDelegate, VLBItemsOperationDelegate, VLBLocationServiceDelegate>

+(VLBProfileViewController *)newProfileViewController:(NSDictionary*)residence email:(NSString*)email;

@end
