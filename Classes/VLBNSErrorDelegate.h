//
//  VLBNSErrorDelegate.h
//  thebox
//
//  Created by Markos Charatzas on 08/12/2012.
//  Copyright (c) 2012 TheBox. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol VLBNSErrorDelegate <NSObject>

/**
 See VLBQueries calls for which methods to implement
*/
@optional
/**
 Callback by VLBQueries when a AFHTTPRequestOperation cannot connect to host.
 
 {code}
 error.code == NSURLErrorCannotConnectToHost
 {code}

 @param error the error as passed on AFHTTPRequestOperation#setCompletionBlockWithSuccess:failure:
 */
-(void)didFailWithCannonConnectToHost:(NSError*)error;

/**
 Callback by VLBQueries when a AFHTTPRequestOperation cannot connect to the internet.
 
 {code}
 error.code == NSURLErrorNotConnectedToInternet
 {code}
 
 @param error the error as passed on AFHTTPRequestOperation#setCompletionBlockWithSuccess:failure:
 */
-(void)didFailWithNotConnectToInternet:(NSError*)error;

/**
 Callback by VLBQueries when a AFHTTPRequestOperation timesout.
 
 {code}
 error.code == NSURLErrorTimedOut
 {code}
 
 @param error the error as passed on AFHTTPRequestOperation#setCompletionBlockWithSuccess:failure:
 */
-(void)didFailWithTimeout:(NSError*)error;

@end
