//
//  TBAFHTTPRequestOperationCompletionBlocks.m
//  thebox
//
//  Created by Markos Charatzas on 08/12/2012.
//  Copyright (c) 2012 TheBox. All rights reserved.
//

#import "TBAFHTTPRequestOperationCompletionBlocks.h"

@implementation TBAFHTTPRequestOperationCompletionBlocks

TBAFHTTPRequestOperationErrorBlock const TB_ERROR_BLOCK_CANNOT_CONNECT_TO_HOST = TB_AFHTTPRequestOperationErrorBlock(NSURLErrorCannotConnectToHost);
TBAFHTTPRequestOperationErrorBlock const TB_ERROR_BLOCK_NOT_CONNECTED_TO_INTERNET = TB_AFHTTPRequestOperationErrorBlock(NSURLErrorNotConnectedToInternet);
TBAFHTTPRequestOperationErrorBlock const TB_ERROR_TIMEOUT =
    TB_AFHTTPRequestOperationErrorBlock(NSURLErrorTimedOut);

@end
