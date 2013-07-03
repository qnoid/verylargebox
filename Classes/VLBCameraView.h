//
// 	VLBCameraView.h
//  verylargebox
//
//  Created by Markos Charatzas on 25/06/2013.
//  Copyright (c) 2013 (verylargebox.com). All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>


/**
 Defines a key for the "meta" dictionary as returned in VLBCameraViewDelegate#cameraView:didFinishTakingPicture:withInfo:meta
 
 @see VLBCameraViewMetaCrop
 @see VLBCameraViewMetaOriginalImage
 */
typedef NSString* VLBCameraViewMeta;

/**
 Key to get a CGRect object, the rectangle in which the full resolution image was cropped at.
 */
extern VLBCameraViewMeta const VLBCameraViewMetaCrop;

/**
 Key to get a UIImage object, the full resolution image as taken by the camera.
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
 
 Will get a callback to customise the underlying AVCaptureConnection when created.
 
 AVCaptureConnection has the following properties already set:

    videoOrientation = AVCaptureVideoOrientationPortrait;
 
 @param cameraView the VLBCameraView instance this delegate is assigned to
 @param captureConnection the AVCaptureConnection instance that will be used to capture the image
 @see AVCaptureSession#captureStillImageAsynchronouslyFromConnection:completionHandler:
 */
-(void)cameraView:(VLBCameraView*)cameraView didCreateCaptureConnection:(AVCaptureConnection*)captureConnection;

/**
 Implement if VLBCameraView.allowPictureRetake is set to YES.
 
 Will get a callaback with the image as returned by the last call to #cameraView:didFinishTakingPicture:info:meta
 
 @param cameraView the VLBCameraView intance that this delegate is assigned to.
 @param image current image currently previewing.
 */
-(void)cameraView:(VLBCameraView*)cameraView willRekatePicture:(UIImage *)image;
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
 Set to true to allow the user to retake a photo by tapping on the preview
 
 @precondition have delegate set
 @precondition have cameraView:didCreateCaptureConnection: implemented
 */
@property(nonatomic, assign) BOOL allowPictureRetake;


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
