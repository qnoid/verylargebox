//
//  VLBCameraTest.m
//  verylargebox
//
//  Created by Markos Charatzas on 29/06/2013.
//  Copyright (c) 2013 verylargebox.com.
//

#import <SenTestingKit/SenTestingKit.h>
#import <Kiwi/Kiwi.h>
#import "VLBCameraView.h"

@interface VLBCameraView (Test)
@property(nonatomic, strong) AVCaptureSession *session;
@property(nonatomic, strong) AVCaptureStillImageOutput *stillImageOutput;
@property(nonatomic, strong) AVCaptureVideoPreviewLayer *videoPreviewLayer;
@property(nonatomic, weak) UIImageView* preview;
@end

@interface VLBCameraViewTest : SenTestCase

@end

@implementation VLBCameraViewTest

@end

SPEC_BEGIN(VLBCameraSpec)

context(@"assert imageview preview will fill its view; given a new VLBCameraView instance, its UIImageView", ^{
    it(@"should have a mode of UIViewContentModeScaleAspectFill and clipToBounds", ^{
        VLBCameraView *cameraView = [[VLBCameraView alloc] initWithFrame:CGRectZero];
        
        [[theValue(cameraView.preview.clipsToBounds) should] equal:theValue(YES)];
        [[theValue(cameraView.preview.contentMode) should] equal:theValue(UIViewContentModeScaleAspectFill)];
    });
});

SPEC_END