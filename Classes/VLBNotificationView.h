//
// 	VLBPostItemOperationDelegate.h
//  verylargebox
//
//  Created by Markos Charatzas on 06/07/2013.
//  Copyright (c) 2013 (verylargebox.com). All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VLBCreateItemOperationDelegate.h"
#import "QNDAnimatedView.h"
#import "VLBNSErrorDelegate.h"

@class VLBProgressView;
@class VLBNotificationView;

@protocol VLBNotificationViewDelegate <NSObject, VLBNSErrorDelegate>

-(void)didCompleteUploading:(VLBNotificationView*)notificationView at:(NSString*)itemURL;
-(void)didStartUploadingItem:(UIImage*)itemImage key:(NSString*)key location:(NSDictionary*) location locality:(NSString*) locality;
-(void)didSucceedWithItem:(NSDictionary*)item;
-(void)didFailOnItemWithError:(NSError*)error;

@end

@interface VLBNotificationView : QNDAnimatedView <VLBCreateItemOperationDelegate>

@property(nonatomic, strong) IBOutlet VLBProgressView *progressView;
@property(nonatomic, weak) id<VLBNotificationViewDelegate> delegate;

+(VLBNotificationView*)newView;

@end
