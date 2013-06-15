//
//  VLBAFHTTPRequestOperationFailureBlockTest.m
//  thebox
//
//  Created by Markos Charatzas on 08/12/2012.
//  Copyright (c) 2012 (verylargebox.com). All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import "VLBAFHTTPRequestOperationCompletionBlocks.h"

@interface VLBAFHTTPRequestOperationFailureBlockTest : SenTestCase

@end

@implementation VLBAFHTTPRequestOperationFailureBlockTest

-(void)testGivenNSURLErrorCannotConnectToHostAssertIsHandledByFailureBlock
{
    NSError* error = [NSError errorWithDomain:@"http://www.foo.bar" code:NSURLErrorCannotConnectToHost userInfo:nil];
        
    STAssertTrue(VLB_ERROR_BLOCK_CANNOT_CONNECT_TO_HOST(error), nil);
}

-(void)testGivenNSURLErrorNotConnectedToInternetAssertIsHandledByFailureBlock
{
    NSError* error = [NSError errorWithDomain:@"http://www.foo.bar" code:NSURLErrorNotConnectedToInternet userInfo:nil];
    
    STAssertTrue(VLB_ERROR_BLOCK_NOT_CONNECTED_TO_INTERNET(error), nil);
}

@end
