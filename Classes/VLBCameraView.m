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

static const NSString *AVCaptureStillImageIsCapturingStillImageContext = @"AVCaptureStillImageIsCapturingStillImageContext";

@interface VLBCameraView ()
@property(nonatomic, weak) IBOutlet UIView* preview;
@property(nonatomic, strong) AVCaptureStillImageOutput *stillImageOutput;

@property(nonatomic, strong) UIView *flashView;

@end

@implementation VLBCameraView

-(void)dealloc
{
    [self.stillImageOutput removeObserver:self
                               forKeyPath:@"capturingStillImage"
                                  context:(__bridge void *)(AVCaptureStillImageIsCapturingStillImageContext)];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    VLB_IF_NOT_SELF_RETURN_NIL();    
    VLB_LOAD_VIEW()
    
return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    VLB_IF_NOT_SELF_RETURN_NIL();    
    VLB_LOAD_VIEW()
    
return self;
}

-(void)awakeFromNib
{
	NSError *error = nil;
	
	AVCaptureSession *session = [AVCaptureSession new];
    [session setSessionPreset:AVCaptureSessionPresetPhoto];
	AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
	AVCaptureDeviceInput *deviceInput = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
    
    if(error){
        [NSException raise:[NSString stringWithFormat:@"Failed with error %d", (int)[error code]]
                    format:[error localizedDescription], nil];
    }
	
    [session addInput:deviceInput];
	
	self.stillImageOutput = [AVCaptureStillImageOutput new];
	[self.stillImageOutput addObserver:self forKeyPath:@"capturingStillImage" options:NSKeyValueObservingOptionNew context:(__bridge void *)(AVCaptureStillImageIsCapturingStillImageContext)];

    [session addOutput:self.stillImageOutput];
		
    AVCaptureVideoPreviewLayer *previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:session];
	previewLayer.backgroundColor = [[UIColor blackColor] CGColor];
	previewLayer.videoGravity = AVLayerVideoGravityResize;
	previewLayer.frame = self.preview.layer.bounds;
	[self.preview.layer addSublayer:previewLayer];
	[session startRunning];
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

- (void)takePicture:(VLBErrorTakingPicture)errorTakingPicture
{
	AVCaptureConnection *stillImageConnection = [self.stillImageOutput connectionWithMediaType:AVMediaTypeVideo];    
    [self cameraView:self didCreateCaptureConnection:stillImageConnection];
    
    VLBCaptureStillImageBlock didFinishTakingPicture = ^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
        if (error) {
            DDLogError(@"%s %@", __PRETTY_FUNCTION__, error);
            errorTakingPicture(error);
        return ;
        }
        
        UIImage *image = [UIImage imageWithData:[AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer]];
        
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            [self cameraView:self didFinishTakingPicture:image editingInfo:nil];
        });
    };
    
    // set the appropriate pixel format / image type output setting depending on if we'll need an uncompressed image for
    // the possiblity of drawing the red square over top or if we're just writing a jpeg to the camera roll which is the trival case
    [self.stillImageOutput setOutputSettings:@{AVVideoCodecKey:AVVideoCodecJPEG}];
	[self.stillImageOutput captureStillImageAsynchronouslyFromConnection:stillImageConnection
                                                  completionHandler:didFinishTakingPicture];
}

// perform a flash bulb animation using KVO to monitor the value of the capturingStillImage property of the AVCaptureStillImageOutput class
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{

	if ( context == (__bridge void *)(AVCaptureStillImageIsCapturingStillImageContext) ) {
		BOOL isCapturingStillImage = [[change objectForKey:NSKeyValueChangeNewKey] boolValue];
		
		if ( isCapturingStillImage ) {
			// do flash bulb like animation
			self.flashView = [[UIView alloc] initWithFrame:[self.preview frame]];
			[self.flashView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"hexabump.png"]]];
			[self.flashView setAlpha:0.f];
			[self.preview addSubview:self.flashView];
			
			[UIView animateWithDuration:.4f
							 animations:^{
								 [self.flashView setAlpha:1.f];
							 }
			 ];
		}
		else {
			[UIView animateWithDuration:.4f
							 animations:^{
								 [self.flashView setAlpha:0.f];
							 }
							 completion:^(BOOL finished){
								 [self.flashView removeFromSuperview];
							 }
			 ];
		}
	}
}

@end
