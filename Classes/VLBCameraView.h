//
// 	VLBCameraView.h
//  verylargebox
//
//  Created by Markos Charatzas on 25/06/2013.
//  Copyright (c) 2013 (verylargebox.com). All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>


typedef NSString* VLBCameraViewMeta;

/**
 
 */
extern VLBCameraViewMeta const VLBCameraViewMetaCrop;

/**
 Use to get the full size image as taken by 
 */
extern VLBCameraViewMeta const VLBCameraViewMetaOriginalImage;

@class VLBCameraView;

@protocol VLBCameraViewDelegate <NSObject>

/**
 Implement to get a callaback on the main thread with the image on VLBCameraView#takePicture: only if an error didn't 
 occur.
 
 @param cameraView the VLBCameraView intance that this delegate is assigned to
 @param image the square cropped image in JPG format using, its size is the maximum used to capture it, its orientation is preserved from the camera.
 @param info
 @param meta
 @see VLBCameraViewMeta
 */
-(void)cameraView:(VLBCameraView*)cameraView didFinishTakingPicture:(UIImage *)image withInfo:(NSDictionary*)info meta:(NSDictionary *)meta;

/**
 Implement to get a callaback on the main thread if an error occurs on VLBCameraView#takePicture:
 
 @param cameraView the VLBCameraView intance that this delegate is assigned to
 @param error the error as returned by AVCaptureSession#captureStillImageAsynchronouslyFromConnection:completionHandler:
 */
-(void)cameraView:(VLBCameraView *)cameraView didErrorOnTakePicture:(NSError *)error;

@optional
/**
 Implement if VLBCameraView.callbackOnDidCreateCaptureConnection is set to YES.
 
 AVCaptureConnection has the following properties set:

    videoOrientation = AVCaptureVideoOrientationPortrait;
 
 @param cameraView the VLBCameraView instance this delegate is assigned to
 @param captureConnection the AVCaptureConnection instance that will be used to capture the image
 @see AVCaptureSession#captureStillImageAsynchronouslyFromConnection:completionHandler:
 */
-(void)cameraView:(VLBCameraView*)cameraView didCreateCaptureConnection:(AVCaptureConnection*)captureConnection;
@end

/**
 A UIView that displays a live feed of AVMediaTypeVideo and can capture a still image from it.
 
 
 
 The view controller that has VLBCameraView in its hierarchy should set the image from cameraView:didFinishTakingPicture:editingInfo #preview.image on #viewWillAppear

 Portrait, iPhone only orientation
 @see 
 */
@interface VLBCameraView : UIView <VLBCameraViewDelegate>

/**
 Set to true to get a callaback to configure AVCaptureConnection
 
 @precondition have delegate set
 @precondition have cameraView:didCreateCaptureConnection: implemented
 */
@property(nonatomic, assign) BOOL callbackOnDidCreateCaptureConnection;

/**
 
 */
@property(nonatomic, assign) IBOutlet NSObject<VLBCameraViewDelegate>* delegate;


/**
 Set backgroundColor to a custom one
 
    backgroundColor = [UIColor whiteColor];
 
 */
@property(nonatomic, strong) UIView *flashView;


/**
 Takes a still image of the current frame from the video feed.
 
 Does not block.
 
 @callback on the main thread at VLBCameraViewDelegate#cameraview:didFinishTakingPicture:editingInfo once the still image is processed.
 */
- (void)takePicture;

@end
