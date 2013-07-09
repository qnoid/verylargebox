//
//  VLBAFHTTPRequestOperationCompletionBlocks.m
//  verylargebox
//
//  Created by Markos Charatzas on 08/12/2012.
//  Copyright (c) 2012 (verylargebox.com). All rights reserved.
//

#import "VLBAFHTTPRequestOperationCompletionBlocks.h"

@implementation VLBAFHTTPRequestOperationCompletionBlocks

VLBAFHTTPRequestOperationErrorBlock const VLB_ERROR_BLOCK_CANNOT_CONNECT_TO_HOST =
    VLB_AFHTTPRequestOperationErrorBlock(NSURLErrorCannotConnectToHost);
VLBAFHTTPRequestOperationErrorBlock const VLB_ERROR_BLOCK_NOT_CONNECTED_TO_INTERNET =
    VLB_AFHTTPRequestOperationErrorBlock(NSURLErrorNotConnectedToInternet);
VLBAFHTTPRequestOperationErrorBlock const VLB_ERROR_TIMEOUT =
    VLB_AFHTTPRequestOperationErrorBlock(NSURLErrorTimedOut);
VLBAFHTTPRequestOperationErrorBlock const VLB_ERROR_CANCELLED =
    VLB_AFHTTPRequestOperationErrorBlock(NSURLErrorCancelled);

@end
