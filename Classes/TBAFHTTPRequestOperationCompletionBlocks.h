//
//  TBAFHTTPRequestOperationCompletionBlocks.h
//  thebox
//
//  Created by Markos Charatzas on 08/12/2012.
//  Copyright (c) 2012 TheBox. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPRequestOperation.h"

@class TBAFHTTPRequestOperationFailureBlockOnErrorCode;

typedef void(^TBAFHTTPRequestOperationCompletionBlock)(AFHTTPRequestOperation *operation);
typedef BOOL(^TBAFHTTPRequestOperationErrorBlock)(NSError *error);

NS_INLINE
TBAFHTTPRequestOperationErrorBlock tbAFHTTPRequestOperationError(NSInteger NSURLErrorCode)
{
    TBAFHTTPRequestOperationErrorBlock requestOperationError = ^BOOL(NSError *error){
        return error.code == NSURLErrorCode;
    };
    
return requestOperationError;
}

/**
 
 **/
NS_INLINE
TBAFHTTPRequestOperationErrorBlock tbErrorBlockCannotConnectToHost(){
return tbAFHTTPRequestOperationError(NSURLErrorCannotConnectToHost);
}

NS_INLINE
TBAFHTTPRequestOperationCompletionBlock tbAFHTTPRequestOperationErrorNoOp() {
return ^(AFHTTPRequestOperation *operation){};
}

/**
  Implementations should handle failures blocks in AFHTTPRequestOperation(s)
 */
@protocol TBAFHTTPRequestOperationFailureBlock <NSObject>

/**
 Handles the failure block.
 
 @param operation the operation in failure under AFHTTPRequestOperation:setCompletionBlockWithSuccess:failure:
 @param error the error in failure under AFHTTPRequestOperation:setCompletionBlockWithSuccess:failure:
 @return YES if the error is handled
 */
-(BOOL)failure:(AFHTTPRequestOperation*) operation error:(NSError*)error;
@end

/**
 Handles a failure block relating to an error code.
 */
@interface TBAFHTTPRequestOperationFailureBlockOnErrorCode : NSObject <TBAFHTTPRequestOperationFailureBlock>

/**
 Creates a new TBAFHTTPRequestOperationFailureBlock to handle a cannot connect to host error.
 
 @param block the block to execute for the error
 @return a new TBAFHTTPRequestOperationFailureBlock that handles an error with code NSURLErrorCannotConnectToHost
 */
+(TBAFHTTPRequestOperationFailureBlockOnErrorCode*)cannotConnectToHost:(TBAFHTTPRequestOperationCompletionBlock)block;

/**
 
 @param operation the operation as passed in failure under AFHTTPRequestOperation:setCompletionBlockWithSuccess:failure:
 @param error the error as passed in failure under AFHTTPRequestOperation:setCompletionBlockWithSuccess:failure:
 @return YES if the error is handled by self
 */
-(BOOL)failure:(AFHTTPRequestOperation*) operation error:(NSError*)error;
@end

/**
 Provides access to all avaible AFHTTPRequestOperation completion blocks that can be used in
 AFHTTPRequestOperation:setCompletionBlockWithSuccess:failure:
 
 */
@interface TBAFHTTPRequestOperationCompletionBlocks : NSObject


@end
