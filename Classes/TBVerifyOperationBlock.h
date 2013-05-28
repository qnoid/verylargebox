//
//  TBVerifyOperationBlock.h
//  thebox
//
//  Created by Markos Charatzas on 10/02/2013.
//  Copyright (c) 2013 TheBox. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TBVerifyUserOperationDelegate.h"

typedef void(^TBDidSucceedWithVerificationForEmail)(NSString* email, NSDictionary* residence);
typedef void(^TBDidFailOnVerifyWithError)(NSError* error);

NS_INLINE
TBDidSucceedWithVerificationForEmail tbEmptyDidSucceedWithVerificationForEmail(){
return ^(NSString* email, NSDictionary* residence){};
}

NS_INLINE
TBDidFailOnVerifyWithError tbEmptyDidFailOnVerifyWithError(){
return ^(NSError* error){};
}

@interface TBVerifyOperationBlock : NSObject <TBVerifyUserOperationDelegate>

@property (nonatomic, copy) TBDidSucceedWithVerificationForEmail didSucceedWithVerificationForEmail;
@property (nonatomic, copy) TBDidFailOnVerifyWithError didFailOnVerifyWithError;
@property (nonatomic, copy) TBDidFailOnVerifyWithError didFailWithNotConnectToInternet;

@end
