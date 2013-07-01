//
//  VLBCameraTest.m
//  verylargebox
//
//  Created by Markos Charatzas on 29/06/2013.
//  Copyright (c) 2013 verylargebox.com.
//

#import <SenTestingKit/SenTestingKit.h>
#import <Kiwi/Kiwi.h>
#import <OCMock/OCMock.h>
#import <AVFoundation/AVFoundation.h>
#import "VLBCameraView.h"

//testing
typedef void(^VLBCaptureStillImageBlock)(CMSampleBufferRef imageDataSampleBuffer, NSError *error);

@interface VLBCameraView (Test)
@property(nonatomic, strong) AVCaptureSession *session;
@property(nonatomic, strong) AVCaptureStillImageOutput *stillImageOutput;
@property(nonatomic, strong) AVCaptureVideoPreviewLayer *videoPreviewLayer;
@property(nonatomic, strong) AVCaptureConnection *stillImageConnection;
@property(nonatomic, weak) UIImageView* preview;

-(VLBCaptureStillImageBlock) didFinishTakingPicture:(AVCaptureSession*) session preview:(UIImageView*)preview videoPreviewLayer:(AVCaptureVideoPreviewLayer*) videoPreviewLayer;
@end

@interface VLBCameraViewTest : SenTestCase

@end

@implementation VLBCameraViewTest

@end

SPEC_BEGIN(VLBCameraSpec)

context(@"assert video preview will fill the camera view; given a new VLBCameraView instance, AVCaptureVideoPreviewLayer", ^{
    it(@"should have videogravity of AVLayerVideoGravityResizeAspectFill", ^{
        VLBCameraView *cameraView = [[VLBCameraView alloc] initWithFrame:CGRectZero];
        
        [[cameraView.videoPreviewLayer.videoGravity should] equal:AVLayerVideoGravityResizeAspectFill];
    });
});

context(@"assert 'white flash' will be shown when photo is taken; given a new VLBCameraView instance", ^{
    it(@"should have a flashview with superlayer of AVCaptureVideoPreviewLayer", ^{
        VLBCameraView *cameraView = [[VLBCameraView alloc] initWithFrame:CGRectZero];
        
        [[cameraView.flashView.layer.superlayer should] equal:cameraView.videoPreviewLayer];
        [[cameraView.flashView.backgroundColor should] equal:[UIColor whiteColor]];
        [[theValue(cameraView.preview.alpha) should] equal:theValue(0.0f)];        
    });
});

context(@"assert delegate gets callbacks; given a new VLBCameraView instance ", ^{
    it(@"should callback its delegate with AVCaptureVideoPreviewLayer when callbackOnDidCreateCaptureConnection is YES", ^{
        
        id mockedDelegate = [OCMockObject mockForProtocol:@protocol(VLBCameraViewDelegate)];
        AVCaptureConnection *mockedCaptureConnection = [OCMockObject niceMockForClass:[AVCaptureConnection class]];
        
        VLBCameraView *cameraView = [[VLBCameraView alloc] initWithCoder:nil];
        cameraView.delegate = mockedDelegate;
        cameraView.callbackOnDidCreateCaptureConnection = YES;
        
        [[mockedDelegate expect] cameraView:cameraView didCreateCaptureConnection:mockedCaptureConnection];
        
        [cameraView cameraView:cameraView didCreateCaptureConnection:mockedCaptureConnection];

        [mockedDelegate verify];
    });
});

SPEC_END
