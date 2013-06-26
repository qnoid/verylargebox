//
// 	VLBObject.m
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

@property(nonatomic, strong) UIView *flashView;
@property(nonatomic, strong) AVCaptureStillImageOutput *stillImageOutput;
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
	
    // Select a video device, make an input
	AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
	AVCaptureDeviceInput *deviceInput = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
    
    if(error){
        [NSException raise:[NSString stringWithFormat:@"Failed with error %d", (int)[error code]]
                    format:[error localizedDescription], nil];
    }
	
	if ( [session canAddInput:deviceInput] )
		[session addInput:deviceInput];
	
    // Make a still image output
	self.stillImageOutput = [AVCaptureStillImageOutput new];
	[self.stillImageOutput addObserver:self forKeyPath:@"capturingStillImage" options:NSKeyValueObservingOptionNew context:(__bridge void *)(AVCaptureStillImageIsCapturingStillImageContext)];
	if ( [session canAddOutput:self.stillImageOutput] )
		[session addOutput:self.stillImageOutput];
	
	
    AVCaptureVideoPreviewLayer *previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:session];
	[previewLayer setBackgroundColor:[[UIColor blackColor] CGColor]];
	[previewLayer setVideoGravity:AVLayerVideoGravityResize];
	CALayer *rootLayer = [self.preview layer];
	[rootLayer setMasksToBounds:YES];
	[previewLayer setFrame:[rootLayer bounds]];
	[rootLayer addSublayer:previewLayer];
	[session startRunning];
}

- (void)takePicture:(id)sender
{
	AVCaptureConnection *stillImageConnection = [self.stillImageOutput connectionWithMediaType:AVMediaTypeVideo];
	[stillImageConnection setVideoOrientation:AVCaptureVideoOrientationPortrait];
	[stillImageConnection setVideoScaleAndCropFactor:1.0];
    // set the appropriate pixel format / image type output setting depending on if we'll need an uncompressed image for
    // the possiblity of drawing the red square over top or if we're just writing a jpeg to the camera roll which is the trival case
    [self.stillImageOutput setOutputSettings:@{AVVideoCodecKey:AVVideoCodecJPEG}];
	[self.stillImageOutput captureStillImageAsynchronouslyFromConnection:stillImageConnection
                                                  completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
        if (error) {
            DDLogError(@"%s %@", __PRETTY_FUNCTION__, error);
        }
        
        UIImage *image = [UIImage imageWithData:[AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer]];        
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            [self.delegate cameraView:self didFinishTakingPicture:image editingInfo:nil];
        });
        }
    ];
}

// perform a flash bulb animation using KVO to monitor the value of the capturingStillImage property of the AVCaptureStillImageOutput class
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{

	if ( context == (__bridge void *)(AVCaptureStillImageIsCapturingStillImageContext) ) {
		BOOL isCapturingStillImage = [[change objectForKey:NSKeyValueChangeNewKey] boolValue];
		
		if ( isCapturingStillImage ) {
			// do flash bulb like animation
			self.flashView = [[UIView alloc] initWithFrame:[self.preview frame]];
			[self.flashView setBackgroundColor:[UIColor whiteColor]];
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
