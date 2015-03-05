//
//  VLBProfileViewController.h
//  verylargebox
//
//  Created by Markos Charatzas on 18/11/2012.
//  Copyright (c) 2012 (verylargebox.com). All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VLBCreateItemOperationDelegate.h"
#import "VLBItemsOperationDelegate.h"
#import "VLBLocationServiceDelegate.h"
#import "VLBView.h"
#import "VLBNotificationView.h"
#import "VLBTakePhotoViewController.h"

@class VLBTheBox;
@class VLBButton;

/**
 
 Subsequent requests to post an item on the server are queued and processed in a FIFO order.
 */
@interface VLBProfileViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, VLBNotificationViewDelegate, VLBItemsOperationDelegate, VLBLocationServiceDelegate, VLBTakePhotoViewControllerDelegate>

@property(nonatomic, weak) IBOutlet UICollectionView* itemsView;
@property(nonatomic, weak) IBOutlet UIButton* takePhotoButton;

+(VLBProfileViewController *)newProfileViewController:(VLBTheBox*)thebox email:(NSString*)email;

-(IBAction)didTouchUpInsideTakePhotoButton;

@end
