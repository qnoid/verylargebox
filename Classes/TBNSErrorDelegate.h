//
//  TBNSErrorDelegate.h
//  thebox
//
//  Created by Markos Charatzas on 08/12/2012.
//  Copyright (c) 2012 TheBox. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TBNSErrorDelegate <NSObject>

@optional
/**
 Callback by TheBoxQueries when a AFHTTPRequestOperation cannot connect to host.
 
 {code}
 error.code == NSURLErrorCannotConnectToHost
 {code}

 @param error the error as passed on AFHTTPRequestOperation#setCompletionBlockWithSuccess:failure:
 */
-(void)didFailWithCannonConnectToHost:(NSError*)error;

/**
 Callback by TheBoxQueries when a AFHTTPRequestOperation cannot connect to the internet.
 
 {code}
 error.code == NSURLErrorNotConnectedToInternet
 {code}
 
 @param error the error as passed on AFHTTPRequestOperation#setCompletionBlockWithSuccess:failure:
 */
-(void)didFailWithNotConnectToInternet:(NSError*)error;

@end
