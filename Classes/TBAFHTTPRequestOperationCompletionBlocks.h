//
//  TBAFHTTPRequestOperationCompletionBlocks.h
//  thebox
//
//  Created by Markos Charatzas on 08/12/2012.
//  Copyright (c) 2012 TheBox. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPRequestOperation.h"

typedef void(^TBAFHTTPRequestOperationCompletionBlock)(AFHTTPRequestOperation *operation, id responseObject);
/**
 Implementations should handle failures blocks in AFHTTPRequestOperation(s)
 @param operation the operation in failure under AFHTTPRequestOperation:setCompletionBlockWithSuccess:failure:
 @param error the error in failure under AFHTTPRequestOperation:setCompletionBlockWithSuccess:failure:
 */
typedef void(^TBAFHTTPRequestOperationFailureBlock)(AFHTTPRequestOperation *operation, NSError *error);

/**
 Handles a failure block relating to an error code.
 */
typedef BOOL(^TBAFHTTPRequestOperationErrorBlock)(NSError *error);

#define TB_AFHTTPRequestOperationErrorBlock(NSURLErrorCode) \
^BOOL(NSError *error){ \
return error.code == NSURLErrorCode; \
};\

/**
 Creates a new TBAFHTTPRequestOperationFailureBlock to handle a cannot connect to host error.
 
 @param block the block to execute for the error
 @return a new TBAFHTTPRequestOperationFailureBlock that handles an error with code NSURLErrorCannotConnectToHost
 */
extern TBAFHTTPRequestOperationErrorBlock const TB_ERROR_BLOCK_CANNOT_CONNECT_TO_HOST;

/**
 Creates a new TBAFHTTPRequestOperationFailureBlock to handle a not connected to the internet error.
 
 @param block the block to execute for the error
 @return a new TBAFHTTPRequestOperationFailureBlock that handles an error with code NSURLErrorNotConnectedToInternet
 */
extern TBAFHTTPRequestOperationErrorBlock const TB_ERROR_BLOCK_NOT_CONNECTED_TO_INTERNET;


/**
 Creates a new TBAFHTTPRequestOperationFailureBlock to handle a timeout.
 
 
 @param block the block to execute for the error
 @return a new TBAFHTTPRequestOperationFailureBlock that handles an error with code NSURLErrorTimedOut
 */
extern TBAFHTTPRequestOperationErrorBlock const TB_ERROR_TIMEOUT;

@interface TBAFHTTPRequestOperationCompletionBlocks : NSObject
@end
