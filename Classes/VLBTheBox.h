//
//  VLBTheBox.h
//  verylargebox
//
//  Created by Markos Charatzas on 16/06/2013.
//  Copyright (c) 2013 (verylargebox.com). All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol VLBCreateItemOperationDelegate;
@class VLBIdentifyViewController;
@class VLBProfileViewController;
@class VLBTakePhotoViewController;

@interface VLBTheBox : NSObject

+(instancetype)newTheBox;

-(void)didSucceedWithVerificationForEmail:(NSString*)email residence:(NSDictionary*)residence; 

-(VLBIdentifyViewController*)newIdentifyViewController;
-(VLBProfileViewController*)newProfileViewController;
-(VLBTakePhotoViewController*)newUploadUIViewController;

/**
 
 @return the key under which will store the image
 */
-(NSString*)newPostImage:(UIImage*)image delegate:(NSObject<VLBCreateItemOperationDelegate>*)delegate;

@end
