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

NSString* const VERYLARGEBOX_BUCKET = @"com.verylargebox.server";
NSString* const AWS_ACCESS_KEY = @"AKIAIFACVDF6VNIEY2EQ";
NSString* const AWS_SECRET_KEY = @"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";


@interface VLBTheBox ()
@property(nonatomic, strong) NSDictionary *residence;
@property(nonatomic, strong) VLBQueries *queries;
@property(nonatomic, strong) S3TransferManager *s3transferManager;

@end

@implementation VLBTheBox

+(instancetype) newTheBox:(NSDictionary *) residence
{
    VLBQueries *queries = [[VLBQueries alloc] init];
    
    S3TransferManager *s3transferManager = [S3TransferManager new];
    
return [[VLBTheBox alloc] init:queries residence:residence transferManager:s3transferManager];
}

-(id)init:(VLBQueries*)queries residence:(NSDictionary*)residence transferManager:(S3TransferManager*) s3transferManager
{
    VLB_INIT_OR_RETURN_NIL();
    
    self.queries = queries;
    self.residence = residence;
    self.s3transferManager = s3transferManager;
    
return self;
}

-(void)newPostImage:(UIImage*)image delegate:(NSObject<VLBCreateItemOperationDelegate>*)delegate
{
    //if residence is nil, runtime error
    
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
}

@end
