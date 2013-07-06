//
//  VLBTheBox.m
//  verylargebox
//
//  Created by Markos Charatzas on 16/06/2013.
//  Copyright (c) 2013 (verylargebox.com). All rights reserved.
//

#import "VLBTheBox.h"
#import "NSDictionary+VLBResidence.h"
#import "VLBMacros.h"
#import "VLBCreateItemOperationDelegate.h"
#import "VLBQueries.h"
#import "S3PutObjectRequest.h"
#import "AmazonEndpoints.h"
#import "S3TransferManager.h"
#import "VLBIdentifyViewController.h"
#import "VLBProfileViewController.h"
#import "VLBTakePhotoViewController.h"
#import "NSDictionary+VLBUser.h"
#import "VLBProfileEmptyViewController.h"

NSString* const VERYLARGEBOX_BUCKET = @"com.verylargebox.server";
NSString* const AWS_ACCESS_KEY = @"AKIAIFACVDF6VNIEY2EQ";
NSString* const AWS_SECRET_KEY = @"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";
NSString * const TESTFLIGHT_TEAM_TOKEN = @"fc2b4104428a1fca89ef4bac9ae1e820_ODU1NzMyMDEyLTA0LTI5IDEyOjE3OjI4LjMwMjc3NQ";
NSString * const TESTFLIGHT_APP_TOKEN = @"0840a56f-799c-4e95-92e9-7e19616a88f7";

@interface VLBTheBox ()
@property(nonatomic, strong) NSString *email;
@property(nonatomic, strong) NSDictionary *residence;
@property(nonatomic, strong) VLBQueries *queries;
@property(nonatomic, strong) S3TransferManager *s3transferManager;

@end

@implementation VLBTheBox

+(instancetype) newTheBox
{
    VLBQueries *queries = [[VLBQueries alloc] init];
    
    S3TransferManager *s3transferManager = [S3TransferManager new];
    
return [[VLBTheBox alloc] init:queries transferManager:s3transferManager];
}

-(id)init:(VLBQueries*)queries transferManager:(S3TransferManager*) s3transferManager
{
    VLB_INIT_OR_RETURN_NIL();
    
    self.queries = queries;
    self.s3transferManager = s3transferManager;
    
return self;
}

-(void)didSucceedWithVerificationForEmail:(NSString*)email residence:(NSDictionary*)residence {
		self.email = email;
	 	self.residence = residence;

    [TestFlight setDeviceIdentifier:[self.residence vlb_objectForKey:VLBResidenceToken]];
    [TestFlight takeOff:TESTFLIGHT_APP_TOKEN];
}

-(VLBIdentifyViewController*)newIdentifyViewController{
return [VLBIdentifyViewController newIdentifyViewController:self];
}

-(VLBProfileViewController*)newProfileViewController {
return [VLBProfileViewController newProfileViewController:self residence:self.residence email:self.email];
}

-(VLBProfileEmptyViewController*)newProfileEmptyViewController{
return [VLBProfileEmptyViewController newProfileViewController:self residence:self.residence email:self.email];
}

-(VLBTakePhotoViewController*)newUploadUIViewController{
return [VLBTakePhotoViewController newUploadUIViewController:self userId:[self.residence vlb_residenceUserId]];
}

-(NSString*)newPostImage:(UIImage*)image delegate:(NSObject<VLBCreateItemOperationDelegate>*)delegate
{
    if(!self.residence){
        [NSException raise:@"Residence should not be nil" format:@"#didAuthenticateResidence should have been called", nil];
    }	
    
    AmazonS3Client *s3 = [[AmazonS3Client alloc] initWithAccessKey:AWS_ACCESS_KEY
                                                     withSecretKey:AWS_SECRET_KEY];
    [s3 setEndpoint:AMAZON_S3_EU_WEST_1_ENDPOINT_SECURE];
    
    self.s3transferManager.s3 = s3;    

    NSString* key = [NSString stringWithFormat:@"%@/%f.jpg",
                     [self.residence vlb_objectForKey:VLBResidenceToken],
                     CACurrentMediaTime()];
    
    S3PutObjectRequest *putImageInBucket = [self.queries newS3PutObjectRequest:@{@"key":key, @"bucket":VERYLARGEBOX_BUCKET} config:^(S3PutObjectRequest *request) {
        VLBS3PutObjectRequestConfigurationImageJpegPublicRead(request);
        request.data = UIImageJPEGRepresentation(image, 1.0);
        request.delegate = delegate;
    }];
    
    [self.s3transferManager upload:putImageInBucket];
    
return key;
}

@end
