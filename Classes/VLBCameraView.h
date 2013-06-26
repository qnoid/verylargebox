//
// 	VLBCameraView.h
//  thebox
//
//  Created by Markos Charatzas on 25/06/2013.
//  Copyright (c) 2013 (verylargebox.com). All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

typedef void(^VLBAVCaptureConnectionConfig)(AVCaptureConnection *captureConnection);
typedef void(^VLBCaptureStillImageBlock)(CMSampleBufferRef imageDataSampleBuffer, NSError *error);
typedef void(^VLBErrorTakingPicture)(NSError *error);

@class VLBCameraView;

@protocol VLBCameraViewDelegate <NSObject>

/**
 Will get a callaback on the main thread witht he 
 
 @param cameraView the VLBCameraView intance that this delegate is assigned to
 @param image the image in JPG format 
 */
-(void)cameraView:(VLBCameraView*)cameraView didFinishTakingPicture:(UIImage *)image editingInfo:(NSDictionary *)editingInfo;

@optional
-(void)cameraView:(VLBCameraView*)cameraView didCreateCaptureConnection:(AVCaptureConnection*)captureConnection;
@end

// Portrait, iPhone only orientation

@interface VLBCameraView : UIView <VLBCameraViewDelegate>

/**
 Set to true to get a callaback to configure AVCaptureConnection
 
 AVCaptureConnection has the following defaults:

 videoOrientation = AVCaptureVideoOrientationPortrait;
 videoScaleAndCropFactor = 1.0;

 @precondition have delegate set
 @precondition have cameraView:didCreateCaptureConnection: implemented
 */
@property(nonatomic, assign) BOOL callbackOnDidCreateCaptureConnection;
@property(nonatomic, assign) IBOutlet NSObject<VLBCameraViewDelegate>* delegate;

/**
 
 @param errorTakingPicture only when an error occures
 */
- (void)takePicture:(VLBErrorTakingPicture)errorTakingPicture;

@end
