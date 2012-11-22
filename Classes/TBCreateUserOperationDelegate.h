//
//  TBRegisterOperationDelegate.h
//  thebox
//
//  Created by Markos Charatzas on 19/11/2012.
//  Copyright (c) 2012 TheBox. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TBCreateUserOperationDelegate <NSObject>

-(void)didSucceedWithRegistrationForEmail:(NSString*)email residence:(NSString*)residence;
-(void)didFailOnRegistrationWithError:(NSError*)error;

@end
