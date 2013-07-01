//
//  VLBVerifyOperationBlock.h
//  verylargebox
//
//  Created by Markos Charatzas on 10/02/2013.
//  Copyright (c) 2013 (verylargebox.com). All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VLBVerifyUserOperationDelegate.h"

typedef void(^VLBDidSucceedWithVerificationForEmail)(NSString* email, NSDictionary* residence);
typedef void(^VLBDidFailOnVerifyWithError)(NSError* error);

NS_INLINE
VLBDidSucceedWithVerificationForEmail vlbEmptyDidSucceedWithVerificationForEmail(){
return ^(NSString* email, NSDictionary* residence){};
}

NS_INLINE
VLBDidFailOnVerifyWithError vlbEmptyDidFailOnVerifyWithError(){
return ^(NSError* error){};
}

@interface VLBVerifyOperationBlock : NSObject <VLBVerifyUserOperationDelegate>

@property (nonatomic, copy) VLBDidSucceedWithVerificationForEmail didSucceedWithVerificationForEmail;
@property (nonatomic, copy) VLBDidFailOnVerifyWithError didFailOnVerifyWithError;
@property (nonatomic, copy) VLBDidFailOnVerifyWithError didFailWithNotConnectToInternet;

@end
