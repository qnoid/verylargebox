//
// 	VLBCameraView.m
//  thebox
//
//  Created by Markos Charatzas on 25/06/2013.
//  Copyright (c) 2013 (verylargebox.com). All rights reserved.
//

#import "VLBCameraView.h"
#import <CoreImage/CoreImage.h>
#import "VLBMacros.h"
#import "DDLog.h"

typedef void(^VLBCaptureStillImageBlock)(CMSampleBufferRef imageDataSampleBuffer, NSError *error);

typedef void(^VLBInit)(VLBCameraView *cameraView);

static NSString* const AVCapturingStillImageKeyPath = @"capturingStillImage";
static void * const AVCapturingStillImage = (void*)&AVCapturingStillImage;

@interface VLBCameraView ()
@property(nonatomic, strong) AVCaptureSession *session;
@property(nonatomic, strong) AVCaptureStillImageOutput *stillImageOutput;
@property(nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;
@property(nonatomic, weak) IBOutlet UIImageView* preview; //test cliptobounds and aspectfill
@end

VLBInit const VLBInitBlock = ^(VLBCameraView *cameraView){
    cameraView.session = [AVCaptureSession new];
    [cameraView.session setSessionPreset:AVCaptureSessionPresetPhoto];
    
    cameraView.flashView = [[UIView alloc] initWithFrame:cameraView.bounds];
    cameraView.flashView.backgroundColor = [UIColor whiteColor];
    cameraView.flashView.alpha = 0.0f;
    [cameraView addSubview:cameraView.flashView]; //test
    
    cameraView.previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:cameraView.session];
	cameraView.previewLayer.backgroundColor = [[UIColor clearColor] CGColor]; //test
	cameraView.previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill; //test
	cameraView.previewLayer.frame = cameraView.preview.layer.bounds;
};

@implementation VLBCameraView

-(void)dealloc
{
    [self.stillImageOutput removeObserver:self
                               forKeyPath:AVCapturingStillImageKeyPath
                                  context:AVCapturingStillImage];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    VLB_IF_NOT_SELF_RETURN_NIL();    
    VLB_LOAD_VIEW()

    VLBInitBlock(self);

return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    VLB_IF_NOT_SELF_RETURN_NIL();    
    VLB_LOAD_VIEW()

    VLBInitBlock(self);
    
return self;
}

-(void)awakeFromNib
{
	NSError *error = nil;
	
	AVCaptureDeviceInput *deviceInput = [AVCaptureDeviceInput deviceInputWithDevice:[AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo] error:&error];
    
    if(error){
        [NSException raise:[NSString stringWithFormat:@"Failed with error %d", (int)[error code]]
                    format:[error localizedDescription], nil];
    }
	
    [self.session addInput:deviceInput];
	
	self.stillImageOutput = [AVCaptureStillImageOutput new];
	[self.stillImageOutput addObserver:self
                            forKeyPath:AVCapturingStillImageKeyPath
                               options:NSKeyValueObservingOptionNew
                               context:AVCapturingStillImage];

    [self.session addOutput:self.stillImageOutput];
		
	[self.preview.layer addSublayer:self.previewLayer];
	[self.session startRunning];
}

-(void)cameraView:(VLBCameraView*)cameraView didCreateCaptureConnection:(AVCaptureConnection*)captureConnection
{
    captureConnection.videoOrientation = AVCaptureVideoOrientationPortrait;
    
    if(self.callbackOnDidCreateCaptureConnection){
        [self.delegate cameraView:cameraView didCreateCaptureConnection:captureConnection];
    }
}

-(void)cameraView:(VLBCameraView *)cameraView didFinishTakingPicture:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    [self.delegate cameraView:self didFinishTakingPicture:image editingInfo:nil];
}

-(void)cameraView:(VLBCameraView *)cameraView didErrorOnTakePicture:(NSError *)error{
    DDLogError(@"%s %@", __PRETTY_FUNCTION__, error);
    [self.delegate cameraView:cameraView didErrorOnTakePicture:error];
}

- (void)takePicture
{
	AVCaptureConnection *stillImageConnection = [self.stillImageOutput connectionWithMediaType:AVMediaTypeVideo];    
    [self cameraView:self didCreateCaptureConnection:stillImageConnection];
    
    VLBCameraView *wself = self;
    VLBCaptureStillImageBlock didFinishTakingPicture = ^(CMSampleBufferRef imageDataSampleBuffer, NSError *error)
    {
        [wself.session stopRunning];
        //[wself.previewLayer removeFromSuperlayer];
        
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^(void) {
                [wself cameraView:wself didErrorOnTakePicture:error];
            });
            
        return;
        }
        
        UIImage *image = [UIImage imageWithData:[AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer]];
        
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            wself.preview.image = image;
            [wself cameraView:wself didFinishTakingPicture:image editingInfo:nil];
        });
    };
    
    // set the appropriate pixel format / image type output setting depending on if we'll need an uncompressed image for
    // the possiblity of drawing the red square over top or if we're just writing a jpeg to the camera roll which is the trival case
    [self.stillImageOutput setOutputSettings:@{AVVideoCodecKey:AVVideoCodecJPEG}];
	[self.stillImageOutput captureStillImageAsynchronouslyFromConnection:stillImageConnection
                                                  completionHandler:didFinishTakingPicture];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
	if (AVCapturingStillImage != context){
        return;
    }
    
    BOOL isCapturingStillImage = [[change objectForKey:NSKeyValueChangeNewKey] boolValue];    
    if(isCapturingStillImage) {
        [UIView animateWithDuration:0.4f
                         animations:^{
                             self.flashView.alpha = 1.0f;
                         }];
    return;
    }

    [UIView animateWithDuration:0.4f
                     animations:^{
            self.flashView.alpha = 0.0f;
        }
        completion:^(BOOL finished){
            [self.flashView removeFromSuperview];
        }];

}

@end
