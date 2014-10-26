//
//  VLBCameraTest.m
//  verylargebox
//
//  Created by Markos Charatzas on 29/06/2013.
//  Copyright (c) 2013 verylargebox.com.
//

#import <XCTest/XCTest.h>
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

@interface VLBCameraViewTestDelegate : NSObject <VLBCameraViewDelegate>
@property(nonatomic, strong) UIImage *image;
@property(nonatomic, strong) NSDictionary *info;
@property(nonatomic, strong) NSDictionary *meta;
@end

@implementation VLBCameraViewTestDelegate

-(void)cameraView:(VLBCameraView *)cameraView didFinishTakingPicture:(UIImage *)image withInfo:(NSDictionary *)info meta:(NSDictionary *)meta{
    self.image = image;
		self.info = info;
		self.meta = meta;
}

-(void)cameraView:(VLBCameraView *)cameraView didErrorOnTakePicture:(NSError *)error{
}

@end


@interface VLBCameraViewTest : XCTestCase

@end

@implementation VLBCameraViewTest

/*
    assert video preview will fill the camera view; given a new VLBCameraView instance, AVCaptureVideoPreviewLayer
    should have videogravity of AVLayerVideoGravityResizeAspectFill
*/
-(void)testGivenNewInstanceAssertAspectFill
{
    VLBCameraView *cameraView = [[VLBCameraView alloc] initWithFrame:CGRectZero];

    XCTAssertEqual(cameraView.videoPreviewLayer.videoGravity, AVLayerVideoGravityResizeAspectFill);
}

/*
 assert 'white flash' will be shown when photo is taken; given a new VLBCameraView instance
 should have a flashview with superlayer of AVCaptureVideoPreviewLayer
*/
-(void)testGivenNewInstanceAssertFlash
{
    VLBCameraView *cameraView = [[VLBCameraView alloc] initWithFrame:CGRectZero];
    
    XCTAssertEqual(cameraView.flashView.layer.superlayer, cameraView.videoPreviewLayer);
    XCTAssertEqual(cameraView.flashView.backgroundColor, [UIColor whiteColor]);
    XCTAssertEqual(cameraView.preview.alpha, 0.0f);
}

/*
 assert delegate gets callbacks; given a new VLBCameraView instance.
 should callback its delegate with AVCaptureVideoPreviewLayer when callbackOnDidCreateCaptureConnection is YES
 */
-(void)testGivenNewInstanceAssertCallbacks
{
    
    id mockedDelegate = [OCMockObject mockForProtocol:@protocol(VLBCameraViewDelegate)];
    AVCaptureConnection *mockedCaptureConnection = [OCMockObject niceMockForClass:[AVCaptureConnection class]];
    
    VLBCameraView *cameraView = [[VLBCameraView alloc] initWithCoder:nil];
    cameraView.delegate = mockedDelegate;
    cameraView.callbackOnDidCreateCaptureConnection = YES;
    
    [[mockedDelegate expect] cameraView:cameraView didCreateCaptureConnection:mockedCaptureConnection];
    
    [cameraView cameraView:cameraView didCreateCaptureConnection:mockedCaptureConnection];

    [mockedDelegate verify];
}
       
/*
 assert camera did finish taking picture of 8mpx image.
 should have an image of specified size correctly orientated with meta.
*/
-(void)testGivenTakePictureAssertOrientation
{

    VLBCameraViewTestDelegate *delegate = [[VLBCameraViewTestDelegate alloc] init];
    VLBCameraView *cameraView = [[VLBCameraView alloc] initWithFrame:CGRectZero];
    cameraView.delegate = delegate;
    id mockedCaptureVideoPreviewLayer = [OCMockObject niceMockForClass:[AVCaptureVideoPreviewLayer class]];
    NSData *imageData = [NSData dataWithContentsOfURL:[[NSBundle bundleForClass:[self class]] URLForResource:@"8mpximage" withExtension:@"png"]];
    UIImage *an8mpxImageAsTakenByCamera = [UIImage imageWithCGImage:[UIImage imageWithData:imageData].CGImage
                                                              scale:1.0f
                                                    orientation:UIImageOrientationRight];
    CGPoint point = CGPointMake(0.124413,1);
    [[[mockedCaptureVideoPreviewLayer stub] andReturnValue:OCMOCK_VALUE(point)] captureDevicePointOfInterestForPoint:CGPointZero];
    cameraView.videoPreviewLayer = mockedCaptureVideoPreviewLayer;



    XCTAssertTrue(CGSizeEqualToSize(delegate.image.size, CGSizeMake(2448, 2449)));
    XCTAssertEqual(delegate.image.imageOrientation, UIImageOrientationRight);
    XCTAssertEqualObjects([delegate.meta objectForKey:VLBCameraViewMetaOriginalImage], an8mpxImageAsTakenByCamera);
    XCTAssertTrue(CGRectEqualToRect([[delegate.meta objectForKey:VLBCameraViewMetaCrop] CGRectValue], CGRectMake(406.08398f, 0.0f, 2448.0f, 2857.916f)));
}

@end