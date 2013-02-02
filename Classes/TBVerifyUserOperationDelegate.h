//
//  TBVerifyUserOperationDelegate.h
//  thebox
//
//  Created by Markos Charatzas on 22/11/2012.
//  Copyright (c) 2012 TheBox. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TBVerifyUserOperationDelegate <NSObject>

/**
 Callback TheBoxQueries#newVerifyUserQuery:email:residence succesfully verifies the user for the given email under
 the given residence.
 
 @param email the email passed in TheBoxQueries#newVerifyUserQuery:email:residence
 @param residence the residence mapping to the JSON as returned by the server.
 */
-(void)didSucceedWithVerificationForEmail:(NSString*)email residence:(NSDictionary*)residence;
-(void)didFailOnVerifyWithError:(NSError*)error;

@end
