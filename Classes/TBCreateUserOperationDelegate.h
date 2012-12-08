//
//  TBRegisterOperationDelegate.h
//  thebox
//
//  Created by Markos Charatzas on 19/11/2012.
//  Copyright (c) 2012 TheBox. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TBNSErrorDelegate.h"

@protocol TBCreateUserOperationDelegate <NSObject, TBNSErrorDelegate>

/**
 Callback by TheBoxQueries#newCreateUserQuery:email: when succesfuly created a user.
 
 @param email the email as entered by the user
 @param residence a residence id created for the user
 */
-(void)didSucceedWithRegistrationForEmail:(NSString*)email residence:(NSString*)residence;

/**
 Callback by TheBoxQueries#newCreateUserQuery:email: when failed to create a user.
 
 @param error the error
 */
-(void)didFailOnRegistrationWithError:(NSError*)error;

@end
