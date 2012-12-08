//
//  TBAFHTTPRequestOperationFailureBlockTest.m
//  thebox
//
//  Created by Markos Charatzas on 08/12/2012.
//  Copyright (c) 2012 TheBox. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import "TBAFHTTPRequestOperationCompletionBlocks.h"

@interface TBAFHTTPRequestOperationFailureBlockTest : SenTestCase

@end

@implementation TBAFHTTPRequestOperationFailureBlockTest

-(void)testGivenNSURLErrorCannotConnectToHostAssertIsHandledByFailureBlock
{
    NSError* error = [NSError errorWithDomain:@"http://www.foo.bar" code:NSURLErrorCannotConnectToHost userInfo:nil];
    
    TBAFHTTPRequestOperationFailureBlockOnErrorCode* cannotConnectToHost =
        [TBAFHTTPRequestOperationFailureBlockOnErrorCode cannotConnectToHost:tbAFHTTPRequestOperationErrorNoOp()];
    
    STAssertTrue([cannotConnectToHost failure:nil error:error], nil);
}
@end
