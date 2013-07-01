//
//  TBRegisterOperationDelegate.h
//  verylargebox
//
//  Created by Markos Charatzas on 19/11/2012.
//  Copyright (c) 2012 (verylargebox.com). All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VLBNSErrorDelegate.h"

@protocol VLBCreateUserOperationDelegate <NSObject, VLBNSErrorDelegate>

/**
 Callback by VLBQueries#newCreateUserQuery:email: when succesfuly created a user.
 
 @param email the email as entered by the user
 @param residence a residence id created for the user
 */
-(void)didSucceedWithRegistrationForEmail:(NSString*)email residence:(NSString*)residence;

/**
 Callback by VLBQueries#newCreateUserQuery:email: when failed to create a user.
 
 @param error the error
 */
-(void)didFailOnRegistrationWithError:(NSError*)error;

@end
