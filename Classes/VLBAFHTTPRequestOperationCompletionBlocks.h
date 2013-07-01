//
//  VLBAFHTTPRequestOperationCompletionBlocks.h
//  verylargebox
//
//  Created by Markos Charatzas on 08/12/2012.
//  Copyright (c) 2012 (verylargebox.com). All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPRequestOperation.h"

typedef void(^VLBAFHTTPRequestOperationCompletionBlock)(AFHTTPRequestOperation *operation, id responseObject);
/**
 Implementations should handle failures blocks in AFHTTPRequestOperation(s)
 @param operation the operation in failure under AFHTTPRequestOperation:setCompletionBlockWithSuccess:failure:
 @param error the error in failure under AFHTTPRequestOperation:setCompletionBlockWithSuccess:failure:
 */
typedef void(^VLBAFHTTPRequestOperationFailureBlock)(AFHTTPRequestOperation *operation, NSError *error);

/**
 Handles a failure block relating to an error code.
 */
typedef BOOL(^VLBAFHTTPRequestOperationErrorBlock)(NSError *error);

#define VLB_AFHTTPRequestOperationErrorBlock(NSURLErrorCode) \
^BOOL(NSError *error){ \
return error.code == NSURLErrorCode; \
};\

/**
 Creates a new VLBAFHTTPRequestOperationFailureBlock to handle a cannot connect to host error.
 
 @param block the block to execute for the error
 @return a new VLBAFHTTPRequestOperationFailureBlock that handles an error with code NSURLErrorCannotConnectToHost
 */
extern VLBAFHTTPRequestOperationErrorBlock const VLB_ERROR_BLOCK_CANNOT_CONNECT_TO_HOST;

/**
 Creates a new VLBAFHTTPRequestOperationFailureBlock to handle a not connected to the internet error.
 
 @param block the block to execute for the error
 @return a new VLBAFHTTPRequestOperationFailureBlock that handles an error with code NSURLErrorNotConnectedToInternet
 */
extern VLBAFHTTPRequestOperationErrorBlock const VLB_ERROR_BLOCK_NOT_CONNECTED_TO_INTERNET;


/**
 Creates a new VLBAFHTTPRequestOperationFailureBlock to handle a timeout.
 
 
 @param block the block to execute for the error
 @return a new VLBAFHTTPRequestOperationFailureBlock that handles an error with code NSURLErrorTimedOut
 */
extern VLBAFHTTPRequestOperationErrorBlock const VLB_ERROR_TIMEOUT;

@interface VLBAFHTTPRequestOperationCompletionBlocks : NSObject
@end
