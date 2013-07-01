//
// 	VLBCameraView.m
//  verylargebox
//
//  Created by Markos Charatzas on 25/06/2013.
//  Copyright (c) 2013 (verylargebox.com). All rights reserved.
//

#import "VLBCameraView.h"
#import <AVFoundation/AVFoundation.h>
#import <CoreImage/CoreImage.h>
#import "VLBMacros.h"
#import "DDLog.h"

typedef void(^VLBCaptureStillImageBlock)(CMSampleBufferRef imageDataSampleBuffer, NSError *error);
typedef void(^VLBCameraViewInit)(VLBCameraView *cameraView);

VLBCameraViewMeta const VLBCameraViewMetaCrop = @"VLBCameraViewMetaCrop";
VLBCameraViewMeta const VLBCameraViewMetaOriginalImage = @"VLBCameraViewMetaOriginalImage";

@interface VLBCameraView ()
@property(nonatomic, strong) AVCaptureSession *session;
@property(nonatomic, strong) AVCaptureStillImageOutput *stillImageOutput;
@property(nonatomic, strong) AVCaptureVideoPreviewLayer *videoPreviewLayer;
@property(nonatomic, strong) AVCaptureConnection *stillImageConnection;
@property(nonatomic, weak) IBOutlet UIImageView* preview;
@end

VLBCameraViewInit const VLBCameraViewInitBlock = ^(VLBCameraView *cameraView){
    cameraView.session = [AVCaptureSession new];
    [cameraView.session setSessionPreset:AVCaptureSessionPresetPhoto];
    
    cameraView.videoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:cameraView.session];
	cameraView.videoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
	cameraView.videoPreviewLayer.frame = cameraView.layer.bounds;
    
    cameraView.flashView = [[UIView alloc] initWithFrame:cameraView.preview.bounds];
    cameraView.flashView.backgroundColor = [UIColor whiteColor];
    cameraView.flashView.alpha = 0.0f;
    [cameraView.videoPreviewLayer addSublayer:cameraView.flashView.layer];
};

@implementation VLBCameraView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    VLB_IF_NOT_SELF_RETURN_NIL();    
    VLB_LOAD_VIEW()

    VLBCameraViewInitBlock(self);

return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    VLB_IF_NOT_SELF_RETURN_NIL();    
    VLB_LOAD_VIEW()

    VLBCameraViewInitBlock(self);
    
return self;
}

-(VLBCaptureStillImageBlock) didFinishTakingPicture:(AVCaptureSession*) session preview:(UIImageView*) preview
{
    VLBCameraView *wself = self;
    
return ^(CMSampleBufferRef imageDataSampleBuffer, NSError *error)
    {
        [session stopRunning];
        
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^(void) {
                [wself cameraView:wself didErrorOnTakePicture:error];
            });
            
        return;
        }
        
        UIImage *image = [UIImage imageWithData:[AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer]];
        CFDictionaryRef attachments = CMCopyDictionaryOfAttachments(kCFAllocatorDefault,
                                                                    imageDataSampleBuffer,
                                                                    kCMAttachmentMode_ShouldPropagate);
        
        dispatch_async(dispatch_get_main_queue(), ^(void)
        {
            preview.image = image;
            
            NSDictionary *info = (__bridge NSDictionary*)attachments;
            
            [wself cameraView:wself didFinishTakingPicture:image withInfo:info meta:nil];
            
            CFRelease(attachments);
        });
    };
}

-(void)awakeFromNib
{
	NSError *error = nil;
	    
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    if ([device isFocusModeSupported:AVCaptureFocusModeContinuousAutoFocus]) {
		NSError *error;
		if ([device lockForConfiguration:&error]) {
			device.focusMode = AVCaptureFocusModeContinuousAutoFocus;
			[device unlockForConfiguration];
        }
    }        

	AVCaptureDeviceInput *deviceInput = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
    
    if(error){
        [NSException raise:[NSString stringWithFormat:@"Failed with error %d", (int)[error code]]
                    format:[error localizedDescription], nil];
    }
	
    [self.session addInput:deviceInput];
	
	self.stillImageOutput = [AVCaptureStillImageOutput new];
    [self.session addOutput:self.stillImageOutput];
		
	[self.layer addSublayer:self.videoPreviewLayer];
	[self.session startRunning];
    
    self.stillImageConnection = [self.stillImageOutput connectionWithMediaType:AVMediaTypeVideo];
    [self cameraView:self didCreateCaptureConnection:self.stillImageConnection];
}

-(void)cameraView:(VLBCameraView*)cameraView didCreateCaptureConnection:(AVCaptureConnection*)captureConnection
{
    captureConnection.videoOrientation = AVCaptureVideoOrientationPortrait;
    
    if(self.callbackOnDidCreateCaptureConnection){
        [self.delegate cameraView:cameraView didCreateCaptureConnection:captureConnection];
    }
}

-(void)cameraView:(VLBCameraView *)cameraView didFinishTakingPicture:(UIImage *)image withInfo:(NSDictionary *)info meta:(NSDictionary *)meta
{
    //point is in range 0..1
    CGPoint point = [self.videoPreviewLayer captureDevicePointOfInterestForPoint:CGPointZero];
    
    //point is calculated with camera in landscape but crop is in portrait
    CGRect crop = CGRectMake(image.size.height - (image.size.height * (1.0f - point.x)),
                             CGPointZero.y,
                             image.size.width,
                             image.size.height * (1.0f - point.x));
    
    CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], crop);
    UIImage *newImage = [UIImage imageWithCGImage:imageRef scale:1.0f orientation:image.imageOrientation]; //preserve camera orientation
    CGImageRelease(imageRef);

    
    [self.delegate cameraView:self
       didFinishTakingPicture:newImage
                     withInfo:info meta:@{VLBCameraViewMetaCrop:[NSValue valueWithCGRect:crop],
                                          VLBCameraViewMetaOriginalImage:image}];
}

-(void)cameraView:(VLBCameraView *)cameraView didErrorOnTakePicture:(NSError *)error{
    DDLogError(@"%s %@", __PRETTY_FUNCTION__, error);
    [self.delegate cameraView:cameraView didErrorOnTakePicture:error];
}

- (void)takePicture
{
    [UIView animateWithDuration:0.4f
                     animations:^{ self.flashView.alpha = 1.0f; }
                     completion:^(BOOL finished){ [self.flashView.layer removeFromSuperlayer]; }
     ];
    
    VLBCaptureStillImageBlock didFinishTakingPicture = [self didFinishTakingPicture:self.session
                                                                            preview:self.preview];
    
    // set the appropriate pixel format / image type output setting depending on if we'll need an uncompressed image for
    // the possiblity of drawing the red square over top or if we're just writing a jpeg to the camera roll which is the trival case
    [self.stillImageOutput setOutputSettings:@{AVVideoCodecKey:AVVideoCodecJPEG}];
	[self.stillImageOutput captureStillImageAsynchronouslyFromConnection:self.stillImageConnection
                                                  completionHandler:didFinishTakingPicture];
}

@end
