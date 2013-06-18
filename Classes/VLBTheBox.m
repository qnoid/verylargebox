//
//  VLBTheBox.m
//  thebox
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

NSString* const VERYLARGEBOX_BUCKET = @"com.verylargebox.server";

@interface VLBTheBox ()
@property(nonatomic, strong) NSDictionary *residence;
@property(nonatomic, strong) VLBQueries *queries;
@end

@implementation VLBTheBox

+(instancetype) newTheBox:(NSDictionary *) residence
{
    VLBQueries *queries = [[VLBQueries alloc] init];
    
return [[VLBTheBox alloc] init:queries residence:residence];
}

-(id)init:(VLBQueries*)queries residence:(NSDictionary*)residence
{
    VLB_INIT_OR_RETURN_NIL();
    
    self.queries = queries;
    self.residence = residence;
    
return self;
}

-(void)newPostImage:(UIImage*)image delegate:(NSObject<VLBCreateItemOperationDelegate>*)delegate
{
    //if residence is nil, runtime error
    
    VLBQueryBlock putImageInBucket = [self.queries newS3PutObjectRequest:^(S3PutObjectRequest *request) {
        VLBS3PutObjectRequestConfigurationImageJpegPublicRead(request);
        request.data = UIImageJPEGRepresentation(image, 1.0);
        request.delegate = delegate;
    }];
    
    NSString* key = [NSString stringWithFormat:@"%@/%f.jpg",
                        [self.residence vlb_objectForKey:VLBResidenceToken],
                        CACurrentMediaTime()];
    
    putImageInBucket(@{@"key":key, @"endpoint":AMAZON_S3_EU_WEST_1_ENDPOINT_SECURE, @"bucket":VERYLARGEBOX_BUCKET});
}

@end
