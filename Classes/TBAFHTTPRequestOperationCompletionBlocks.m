//
//  TBAFHTTPRequestOperationCompletionBlocks.m
//  thebox
//
//  Created by Markos Charatzas on 08/12/2012.
//  Copyright (c) 2012 TheBox. All rights reserved.
//

#import "TBAFHTTPRequestOperationCompletionBlocks.h"

@interface TBAFHTTPRequestOperationFailureBlockOnErrorCode()
@property(nonatomic, copy)TBAFHTTPRequestOperationErrorBlock errorBlock;
@property(nonatomic, copy)TBAFHTTPRequestOperationCompletionBlock block;
-(id)initWithCompletionBlock:(TBAFHTTPRequestOperationCompletionBlock)block forError:(TBAFHTTPRequestOperationErrorBlock)errorBlock;
@end

@implementation TBAFHTTPRequestOperationFailureBlockOnErrorCode

+(TBAFHTTPRequestOperationFailureBlockOnErrorCode*)cannotConnectToHost:(TBAFHTTPRequestOperationCompletionBlock)block {
return [[TBAFHTTPRequestOperationFailureBlockOnErrorCode alloc] initWithCompletionBlock:block forError:tbErrorBlockCannotConnectToHost()];
}

+(TBAFHTTPRequestOperationFailureBlockOnErrorCode*)notConnectedToInternet:(TBAFHTTPRequestOperationCompletionBlock)block {
return [[TBAFHTTPRequestOperationFailureBlockOnErrorCode alloc] initWithCompletionBlock:block forError:tbErrorBlockNotConnectedToInternet()];
}

-(id)initWithCompletionBlock:(TBAFHTTPRequestOperationCompletionBlock)block forError:(TBAFHTTPRequestOperationErrorBlock)errorBlock
{
    self = [super init];
    
    if(!self){
        return nil;
    }
    
    self.block = block;
    self.errorBlock = errorBlock;
    
return self;
}

-(BOOL)failure:(AFHTTPRequestOperation*) operation error:(NSError*)error
{
    NSLog(@"WARNING: %s %@", __PRETTY_FUNCTION__, error);

    if(!self.errorBlock(error)){
        return NO;
    }
    
    self.block(operation);
    
return YES;
}
@end

@implementation TBAFHTTPRequestOperationCompletionBlocks

@end
